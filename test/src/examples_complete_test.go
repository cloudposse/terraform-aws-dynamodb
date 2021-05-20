package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// Test the Terraform module in examples/complete using Terratest.
func TestExamplesComplete(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../../examples/complete",
		Upgrade:      true,
		// Variables to pass to our Terraform code using -var-file options
		VarFiles: []string{"fixtures.us-east-2.tfvars"},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform plan` and fail the test if there are any errors
	terraform.InitAndPlan(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the value of an output variable
	tableName1 := terraform.Output(t, terraformOptions, "table_name_1")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "eg-test-first", tableName1)

	// Run `terraform output` to get the value of an output variable
	tableArn1 := terraform.Output(t, terraformOptions, "table_arn_1")
	// Verify we're getting back the outputs we expect
	assert.Contains(t, tableArn1, "table/eg-test-first")

	// Run `terraform output` to get the value of an output variable
	tableName2 := terraform.Output(t, terraformOptions, "table_name_2")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "eg-test-second", tableName2)

	// Run `terraform output` to get the value of an output variable
	tableArn2 := terraform.Output(t, terraformOptions, "table_arn_2")
	// Verify we're getting back the outputs we expect
	assert.Contains(t, tableArn2, "table/eg-test-second")

}
