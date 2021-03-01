source <(kubectl completion zsh)  # setup autocomplete in zsh into the current shell
alias k=kubectl
export KUBE_EDITOR="vim"
alias pods-by-node="kubectl get pod -o=custom-columns=NODE:.spec.nodeName,NAMESPACE:.metadata.namespace,NAME:.metadata.name"
