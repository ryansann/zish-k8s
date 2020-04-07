function exit_code
  set -l exit_code $status
 
  if test $exit_code -ne 0
    set_color red
  else
    set_color green
  end
 
  printf '%d' $exit_code
  set_color yellow
 
  printf ' < %s' (date +%H:%M:%S)
  set_color normal
end

function fish_right_prompt
  echo (exit_code)
end