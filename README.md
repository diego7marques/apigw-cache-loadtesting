# apigw-cache-loadtesting
Is the Amazon API Gateway cache feature a game changer?
📄 The files available in this repository are from the [Is the Amazon API Gateway cache feature a game changer?](https://containscloud.com/2024/09/02/is-the-amazon-api-gateway-cache-feature-a-game-changer/) blog post of  [contains(cloud)](https://containscloud.com) ☁️

![architecture](https://containscloud.com/wp-content/uploads/2024/09/apigw-cache-1.png)

Technologies used:

[![MySkills](https://skillicons.dev/icons?i=aws,terraform,js,)](#)

## How to run the terraform

1. Export the environment variables of `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_SESSION_TOKEN` and `AWS_DEFAULT_REGION`.

2. Navigate to `terraform/` folder.

3. Run `terraform init`

4. Run `terraform apply`

## How to run the load testing

1. Download and install [k6](https://k6.io/)

2. Navigate to `stress_test/` folder.

3. Run one of:

* Without cache: `API_PATH=/nocache/app k6 run stress_test.js`
* With cache: `API_PATH=/cache/app k6 run stress_test.js`

## License

This code is licensed under the [MIT License](LICENSE).