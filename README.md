[切换至中文](README_zh.md)
# gcp-alert-push
## step 0 : setup gcloud application default login
```
gcloud auth application-default login
```
## step 1 : install cloud function lib
```
cd ~/gcp-alert-push

cp -R function-src/ function-build/
cd function-build
pip install -r requirement.txt -t .

```
## step 2 : deploy example with cli var args [please replace upper case value with your's]
```
cd ~/gcp-alert-push
# init terraform dependency
terraform init

# deploy with var parameters
terraform apply --auto-approve -var="project_id=PROJECT_ID" -var="region=REGION" -var="cloudfunctions_source_code_path=SRC_BUILD_PATH" -var="wechat_webhook=URL" -var="dingtalk_webhook=URL"
```

## step 2 (option): deploy example with var file
```
cd ~/gcp-alert-push
# create var file with like this[ please replace xxx with your's]
cat > testing.tfvars << EOF
project_id = "xxx"
region     = "us-central1"
cloudfunctions_source_code_path = "./function-build/"
wechat_webhook="xxx"
dingtalk_webhook="xxx"
EOF

# init terraform dependency
terraform init

# deploy with var file
terraform apply -var-file="testing.tfvars" --auto-approve

```

## step 3 : destroy all resource
```
terraform destroy --auto-approve
```