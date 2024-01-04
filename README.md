# gcp-alert-push
## install cloud function lib
```
cp -R function-src/ function-build/
cd function-build
pip install -r requirement.txt -t .

```
## deploy option 1
```
terraform apply --auto-approve -var="project_id=PROJECT_ID" -var="region=REGION" -var="cloudfunctions_source_code_path=SRC_BUILD_PATH" -var="wechat_webhook=URL" -var="dingtalk_webhook=URL"
```

## deploy option 2
```
# create var file with like this please replace xxx with your values:
cat > testing.tfvars << EOF
project_id = "xxx"
region     = "us-central1"
cloudfunctions_source_code_path = "./function-build/"
wechat_webhook="xxx"
dingtalk_webhook="xxx"
EOF

# deploy with var
terraform apply -var-file="testing.tfvars" --auto-approve

```

## destroy all resource
```
terraform destroy --auto-approve
```