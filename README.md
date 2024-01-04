# gcp-alert-push
## install cloud function lib
```
cp -R function-src/ function-build/
cd function-build
pip install -r requirement.txt -t .

```
## deploy
```
terraform apply --auto-approve -var="project_id=PROJECT_ID" -var="region=REGION" -var="cloudfunctions_source_code_path=PATH" -var="alert_channel_webhook_url=URL"
```