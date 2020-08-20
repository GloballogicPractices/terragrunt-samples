package testing

import (
	"fmt"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/suite"
	"testing"
)

type resourceGroupSuite struct {
	terraformOptions *terraform.Options
	fixturefolde     string
	suite.Suite
}

func TestInputOutput(t *testing.T) {
	suite.Run(t, new(resourceGroupSuite))
}

//func (suite *resourcegroupSuite) TearDownTest() {
//	fmt.Println("This will run after every test")
//}
func (suite *resourceGroupSuite) SetupSuite() {

	fixtureDir := "./fixture"
	suite.fixturefolde = fixtureDir
	terraformOptions := &terraform.Options{

		TerraformDir: fixtureDir,
	}

	terraform.InitAndApply(suite.T(), terraformOptions)

	suite.terraformOptions = terraformOptions
	fmt.Println("This will run once before one suite test")
}

func (suite *resourceGroupSuite) TearDownSuite() {
	fmt.Println("This will run once after one suite test")
	terraform.Destroy(suite.T(), suite.terraformOptions)

}

//func (t *inputoutsuite) SetupTest() {
//	fmt.Println("this is run before every test")
//}

func (a resourceGroupSuite) TestOne() {
	actualOuputName := terraform.Output(a.T(), a.terraformOptions, "resource_group_name")
	a.Equal("voyager-infra-test-centralus-rg-unit-test", actualOuputName)
}

func (a resourceGroupSuite) TestTwo() {
	actualOutputLocation := terraform.Output(a.T(), a.terraformOptions, "resource_group_location")
	a.Equal("centralus", actualOutputLocation)
}
