#!/usr/bin/env bash
NS=zeitview

set -euo pipefail

echo "Listing pods..."
kubectl -n $NS get pods -l app=app-a -o wide
kubectl -n $NS get pods -l app=app-b -o wide
kubectl -n $NS get pods -l app=app-c -o wide

POD_A=$(kubectl -n $NS get pods -l app=app-a -o jsonpath='{.items[0].metadata.name}')
POD_B=$(kubectl -n $NS get pods -l app=app-b -o jsonpath='{.items[0].metadata.name}')
POD_C=$(kubectl -n $NS get pods -l app=app-c -o jsonpath='{.items[0].metadata.name}')

SVC_A=app-a-svc.${NS}.svc.cluster.local
SVC_B=app-b-svc.${NS}.svc.cluster.local
SVC_C=app-c-svc.${NS}.svc.cluster.local

echo
echo "From app-a pod ($POD_A):"
kubectl -n $NS exec -it $POD_A -- sh -c "echo 'curl -> app-b'; curl -s -S --max-time 5 http://${SVC_B} || echo 'FAILED'; echo 'curl -> app-c'; curl -s -S --max-time 5 http://${SVC_C} || echo 'FAILED'"

echo
echo "From app-b pod ($POD_B):"
kubectl -n $NS exec -it $POD_B -- sh -c "echo 'curl -> app-a'; curl -s -S --max-time 5 http://${SVC_A} || echo 'FAILED'; echo 'curl -> app-c'; curl -s -S --max-time 5 http://${SVC_C} || echo 'FAILED'"

echo
echo "From app-c pod ($POD_C):"
kubectl -n $NS exec -it $POD_C -- sh -c "echo 'curl -> app-b (should PASS)'; curl -s -S --max-time 5 http://${SVC_B} || echo 'FAILED'; echo 'curl -> app-a (should FAIL)'; curl -s -S --max-time 5 http://${SVC_A} && echo 'UNEXPECTED PASS' || echo 'EXPECTED FAIL or TIMEOUT'"

echo
echo "Validation complete. Expected: app_c -> app_a should not reach (EXPECTED FAIL)."
