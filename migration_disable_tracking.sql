-- Migration script to disable email tracking for existing records
-- Run this script to update existing tasks and API templates to have tracking disabled
-- This is a one-time migration for existing installations

-- Update existing email tasks to disable tracking
UPDATE email_tasks 
SET track_open = 0, track_click = 0 
WHERE track_open = 1 OR track_click = 1;

-- Update existing API templates to disable tracking
UPDATE api_templates 
SET track_open = 0, track_click = 0 
WHERE track_open = 1 OR track_click = 1;

-- Verify the changes
-- SELECT COUNT(*) as tasks_with_tracking_enabled FROM email_tasks WHERE track_open = 1 OR track_click = 1;
-- SELECT COUNT(*) as api_templates_with_tracking_enabled FROM api_templates WHERE track_open = 1 OR track_click = 1;
