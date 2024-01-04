# gcp-alert-push
## install function lib
```
cp -R function-src/ function-build/
cd function-build
pip install -r requirement.txt -t .

```
## deploy
```
terraform apply --auto-approve
```