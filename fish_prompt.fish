# name: Zish

function _is_git_dirty
  echo (command git status -s --ignore-submodules=dirty 2> /dev/null)
end

function kubectl_status
  [ -z "$KUBECTL_PROMPT_ICON" ]; and set -l KUBECTL_PROMPT_ICON "⎈"
  [ -z "$KUBECTL_PROMPT_SEPARATOR" ]; and set -l KUBECTL_PROMPT_SEPARATOR "/"
  set -l config $KUBECONFIG
  [ -z "$config" ]; and set -l config "$HOME/.kube/config"
  if [ ! -f $config ]
    return
  end

  set -l ctx (kubectl config current-context 2>/dev/null)
  if [ $status -ne 0 ]
    return
  end

  set -l ns (kubectl config view -o "jsonpath={.contexts[?(@.name==\"$ctx\")].context.namespace}")
  [ -z $ns ]; and set -l ns 'default'

  echo (set_color green)$KUBECTL_PROMPT_ICON" "(set_color purple)"$ctx$KUBECTL_PROMPT_SEPARATOR$ns"
end

function fish_prompt
  # line 1
  set_color -o red
  printf '┌─<'

  # user
  set_color -o blue
  printf '%s ' (whoami)
  set_color $fish_color_autosuggestion[1]
  
  # host
  printf '@ '
  set_color cyan
  printf '%s ' (hostname|cut -d . -f 1)
  set_color $fish_color_autosuggestion[1]
  
  # short path
  printf 'in '
  set_color -o green
  printf '%s' (prompt_pwd)
  set_color -o red
  printf '>'

  # line 2
  echo
  set_color -o red
  printf '└─<'
  set_color yellow

  # git
  printf '%s' (__fish_git_prompt)
  if [ (_is_git_dirty) ]
    set_color blue
    printf '* '
  end

  # k8s
  set -l k8s (kubectl_status)
  if [ ! -z "$k8s" ]
    set_color -o purple
    printf '['
    printf '%s' (kubectl_status)
    set_color -o purple
    printf '] '
  end

  set_color -o red
  printf '>──'
  set_color yellow
  printf '» '
  set_color normal
end