# gcp-alert-push
## 步骤 0 : 配置gcloud认证
```
gcloud auth application-default login
```
## 步骤 1 : 安装cloud function python代码依赖
```
cd ~/gcp-alert-push

cp -R function-src/ function-build/
cd function-build
pip install -r requirement.txt -t .

```
## 步骤 2 : 使用cli变量参数部署 [注意替换大写内容为你项目相关的值]
```
cd ~/gcp-alert-push

# terraform初始化
terraform init

# 部署
terraform apply --auto-approve -var="project_id=PROJECT_ID" -var="region=REGION" -var="cloudfunctions_source_code_path=SRC_BUILD_PATH" -var="wechat_webhook=URL" -var="dingtalk_webhook=URL"
```

## 步骤 2 (可选): 使用变量文件部署[注意替换xxx为你项目相关的值]
```
cd ~/gcp-alert-push

# 创建testing.tfvars变量文件[ 注意替换 xxx 内容,如果只发送微信消息则需要把dingtalk_webhook变量内容删掉,只发送钉钉消息同理]

cat > testing.tfvars << EOF
project_id = "xxx"
region     = "us-central1"
cloudfunctions_source_code_path = "./function-build/"
wechat_webhook="xxx"
dingtalk_webhook="xxx"
EOF

# terraform初始化
terraform init

# 部署
terraform apply -var-file="testing.tfvars" --auto-approve

```

## step 3 : 销毁部署的资源
```
terraform destroy --auto-approve
```