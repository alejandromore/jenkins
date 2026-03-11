kubectl argo rollouts get rollout demo-rollout -n rollout-demo --watch

STEP 1  setWeight 20
STEP 2  pause
STEP 3  setWeight 50
STEP 4  pause


kubectl argo rollouts promote demo-rollout -n rollout-demo