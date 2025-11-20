package v1

import (
	"reflect"
	"testing"

	"github.com/gogf/gf/v2/util/gvalid"
)

// TestCreateTaskReq_DefaultValues verifies that tracking defaults are disabled (0)
func TestCreateTaskReq_DefaultValues(t *testing.T) {
	// Create a request with minimal required fields
	req := &CreateTaskReq{
		Addresser:  "test@example.com",
		Subject:    "Test Subject",
		TemplateId: 1,
		GroupId:    1,
		StartTime:  1234567890,
	}

	// Use gvalid to apply defaults as the framework would
	validator := gvalid.New()
	err := validator.Data(req).Run(nil)
	if err != nil {
		t.Logf("Validation errors (expected for some fields): %v", err)
	}

	// The important check: verify defaults in struct tags
	// Check that TrackOpen default is "0"
	trackOpenField, ok := getStructTagDefault(CreateTaskReq{}, "TrackOpen")
	if !ok {
		t.Error("TrackOpen field not found")
	}
	if trackOpenField != "0" {
		t.Errorf("TrackOpen default = %v, want 0", trackOpenField)
	}

	// Check that TrackClick default is "0"
	trackClickField, ok := getStructTagDefault(CreateTaskReq{}, "TrackClick")
	if !ok {
		t.Error("TrackClick field not found")
	}
	if trackClickField != "0" {
		t.Errorf("TrackClick default = %v, want 0", trackClickField)
	}
}

// Helper function to extract default value from struct tag
func getStructTagDefault(s interface{}, fieldName string) (string, bool) {
	// Use reflection to get struct tags
	t := reflect.TypeOf(s)
	if t.Kind() != reflect.Struct {
		return "", false
	}

	for i := 0; i < t.NumField(); i++ {
		field := t.Field(i)
		if field.Name == fieldName {
			tag := field.Tag.Get("default")
			return tag, true
		}
	}
	return "", false
}
