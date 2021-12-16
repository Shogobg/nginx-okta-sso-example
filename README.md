# Single sign-on using Open ID Connect with Okta, Nginx and Vouch-Proxy

This repository contains the minimal setup needed to protect a web page using SSO, Nginx, and Vouch-Proxy, through Okta identity provider.

This setup is configured to work on a single domain - if you're looking for a multi-domain setup, open an issue an I'll do what I can to help you.

## Setup

### Register for a developers' account with Okta

Instructions on how to register an account in Okta, and how to configure an OIDC application are available in [this blog article][okta-app-howto].

### Configure Vouch Proxy with your Okta application details

Vouch Proxy supports two types of configuration:

1. Through [configuration file][vp-config];
1. Through environmental variables;

   Note: you can also see the environmental variables' names at the link to the configuration file above.

This example uses environmental variables for configuration.

You need to set the following environment variables, so Vouch Proxy can run correctly:

```bash
  OAUTH_CLIENT_ID=<your_client_id>
  OAUTH_CLIENT_SECRET=<your_client_secret>
  OAUTH_PROVIDER=oidc                                                                 # Currently only OIDC is supported
  OAUTH_CODE_CHALLENGE_METHOD=S256                                                    # You can leave this as it is
  OAUTH_AUTH_URL=https://dev-<your_id>.okta.com/oauth2/default/v1/authorize           # Remember to change "<your_id>" to your SSO account URL
  OAUTH_TOKEN_URL=https://dev-<your_id>.okta.com/oauth2/default/v1/token              # Remember to change "<your_id>" to your SSO account URL
  OAUTH_USER_INFO_URL=https://dev-<your_id>.okta.com/oauth2/default/v1/userinfo       # Remember to change "<your_id>" to your SSO account URL
  OAUTH_END_SESSION_ENDPOINT=https://dev-<your_id>.okta.com/oauth2/default/v1/logout  # Remember to change "<your_id>" to your SSO account URL
  OAUTH_SCOPES=openid,email,profile                                                   # The information we will be requesting from Okta - defaults are okay for now
  OAUTH_CALLBACK_URL=http://localhost:8080/auth                                       # The URL that Okta will redirect the browser to - it should be included in your Okta application configuration
  VOUCH_COOKIE_DOMAIN=localhost                                                       # The domain that will be used to set the authentication cookie
  VOUCH_TESTING=false
  VOUCH_ALLOWALLUSERS=true                                                            # Accept every user that can authenticate with our OAuth URL. Okta supports user groups, which we can use to restrict access.
  VOUCH_COOKIE_SECURE=false                                                           # Set cookie security to true, if you're using HTTPS
  VOUCH_PORT=9090                                                                     # The port at which the Vouch Server will be started
```

### Configuration for Docker

This repository includes a `docker-compose.yml` file, for use with Docker.
To configure Vouch, just set the environment variables, using `export <environment_variable_name>=<value>`, or change the values directly in the `docker-compose.yml` file.

Template to export environmental variables

```bash
export OAUTH_CLIENT_ID=<your_client_id>
export OAUTH_CLIENT_SECRET=<your_client_secret>
export OAUTH_PROVIDER=oidc
export OAUTH_CODE_CHALLENGE_METHOD=S256
export OAUTH_AUTH_URL=https://dev-<your_id>.okta.com/oauth2/default/v1/authorize
export OAUTH_TOKEN_URL=https://dev-<your_id>.okta.com/oauth2/default/v1/token
export OAUTH_USER_INFO_URL=https://dev-<your_id>.okta.com/oauth2/default/v1/userinfo
export OAUTH_END_SESSION_ENDPOINT=https://dev-<your_id>.okta.com/oauth2/default/v1/logout
export OAUTH_SCOPES=openid,email,profile
export OAUTH_CALLBACK_URL=http://localhost:8080/auth
export VOUCH_COOKIE_DOMAIN=localhost
export VOUCH_TESTING=false
export VOUCH_ALLOWALLUSERS=true
export VOUCH_COOKIE_SECURE=false
export VOUCH_PORT=9090
```

### Configure NGINX

There is no special configuration to perform on NGINX, before running this example, however you might want to customize it for your use-case, before deployment.

### Configuration for Kubernetes

The repository includes an example on how to configure this setup, when deploying to Kubernetes - it is located under the folder `.kubernetes`

Note: to use this example, you will need Kustomize

How to setup and deploy the example:

1. Replace the required variables

   `find . -type f -name '*.yaml' -exec sed -i -e 's>{{K8S_NAMESPACE}}>'kubernetes_namespace'>g' {} +`

   `find . -type f -name '*.yaml' -exec sed -i -e 's>{{APP_NAME}}>'nginx'>g' {} +`

   `find . -type f -name '*.yaml' -exec sed -i -e 's>{{DEPLOYMENT_NAME}}>'nginx_sso'>g' {} +`

   `find . -type f -name '*.yaml' -exec sed -i -e 's>{{ENVIRONMENT}}>'beta'>g' {} +`

1. Set your Okta details and Vouch configuration in `sso-secrets.yaml`

1. Run Kustomize

   `kustomize kustomization.yaml`

1. Apply Kubernetes manifest to your cluster

   `kubectl apply -f manifest.yaml`

[okta-app-howto]: https://shogo.eu/blog/2021/11/30/Creating-a-Single-Sign-On-application-in-Okta/
[vp-config]: https://github.com/vouch/vouch-proxy/blob/f8410f4ab8569021c389f7a030254b516ae34980/config/config.yml_example
