package test

import (
	"crypto/tls"
	"fmt"
	"net/http"
	"strings"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/retry"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestS3StaticSiteModule(t *testing.T) {
	t.Parallel()

	// Generate a random bucket suffix to ensure uniqueness
	bucketSuffix := strings.ToLower(random.UniqueId())
	bucketName := fmt.Sprintf("terratest-static-site-%s", bucketSuffix)

	// AWS region for testing
	awsRegion := "us-east-1"

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/s3-static-site",
		Vars: map[string]interface{}{
			"bucket_name": bucketName,
		},
		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": awsRegion,
		},
	})

	// Clean up resources with "terraform destroy" at the end of the test
	defer terraform.Destroy(t, terraformOptions)

	// Run "terraform init" and "terraform apply"
	terraform.InitAndApply(t, terraformOptions)

	// Validate the S3 bucket exists
	aws.AssertS3BucketExists(t, awsRegion, bucketName)

	// Get the CloudFront distribution URL
	cloudfrontURL := terraform.Output(t, terraformOptions, "website_url")
	assert.NotEmpty(t, cloudfrontURL)

	// Validate the website is accessible via CloudFront
	// Note: CloudFront distributions can take several minutes to deploy
	maxRetries := 30
	sleepBetweenRetries := 30 * time.Second

	retry.DoWithRetry(t, "Validate website is accessible", maxRetries, sleepBetweenRetries, func() (string, error) {
		resp, err := httpGetWithTimeout(cloudfrontURL, 10*time.Second)
		if err != nil {
			return "", err
		}

		if resp.StatusCode != 200 {
			return "", fmt.Errorf("expected status code 200, got %d", resp.StatusCode)
		}

		if !strings.Contains(resp.Body, "Static site successfully deployed") {
			return "", fmt.Errorf("expected page content not found")
		}

		return "Website is accessible", nil
	})

	// Test 404 error page
	errorURL := strings.TrimSuffix(cloudfrontURL, "/") + "/nonexistent-page"
	retry.DoWithRetry(t, "Validate 404 error page", 10, 5*time.Second, func() (string, error) {
		resp, err := httpGetWithTimeout(errorURL, 10*time.Second)
		if err != nil {
			return "", err
		}

		if resp.StatusCode != 404 {
			return "", fmt.Errorf("expected status code 404, got %d", resp.StatusCode)
		}

		if !strings.Contains(resp.Body, "Page Not Found") {
			return "", fmt.Errorf("expected 404 page content not found")
		}

		return "404 page is working", nil
	})
}

// httpGetWithTimeout makes an HTTP GET request with a timeout
func httpGetWithTimeout(url string, timeout time.Duration) (*HTTPResponse, error) {
	client := &http.Client{
		Timeout: timeout,
		Transport: &http.Transport{
			TLSClientConfig: &tls.Config{InsecureSkipVerify: false},
		},
	}

	resp, err := client.Get(url)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	var body strings.Builder
	_, err = body.ReadFrom(resp.Body)
	if err != nil {
		return nil, err
	}

	return &HTTPResponse{
		StatusCode: resp.StatusCode,
		Body:       body.String(),
		Headers:    resp.Header,
	}, nil
}

type HTTPResponse struct {
	StatusCode int
	Body       string
	Headers    http.Header
}
