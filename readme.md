# cambio pendiente
    environment {
        // Provider (para recursos)
        TF_VAR_access_key  = credentials('hwc-provider-ak')
        TF_VAR_secret_key  = credentials('hwc-provider-sk')

        // Backend (para terraform state)
        AWS_ACCESS_KEY_ID     = credentials('hwc-backend-ak')
        AWS_SECRET_ACCESS_KEY = credentials('hwc-backend-sk')
    }

kubectl delete namespace demo-app