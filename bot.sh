say(){
	echo -e "$(color)1,0 $1"
}

say "hello all!"

while true; do 
	cat out >> log.txt;
   
   gm=$(tail out | grep -iP 'goto');
   if [ "$gm" ]; then
      say "$(echo $gm | sed -r 's/goto/[REDACTED]/I')";
   fi

	sub=$(tail out | grep -oP '^s/[^/]*/[^/]*/.?'); 
	if [ "$sub" ]; then 
		a=$(echo $sub | sed -r 's|s/([^/]*)/([^/]*)/.?|\1|')
		#b=$(echo $sub | sed -r 's/s\/([^\/]*)\/([^\/]*)\/(g)?/\2/')
		say "$(tac log.txt | head -n 11 | tail | grep -m 1 -E "$a" | sed -r "$sub")";
	fi; 

	die=$(tail out | grep -oPI '.*\.d[0-9]*' | sed -r 's/[^0-9]*\.d([0-9]*).*/\1/')
	if [ "$die" ]; then
		say "You rolled $(( $RANDOM%$die+1))".
	fi
	
	calc=$(tail out | grep -P '<.*>[ \t]*\.c[ \t]*.*');
	if [ "$calc" ]; then
		calc=$(echo $calc | sed -r 's/.*\.c[ \t]*//');
		say "result: $(timeout 3 bc -l <(echo $calc) 2>&1 | head -c 160)";
	fi

   search=$(tail out | grep -P '<.*>\s*\.g\s*.*');
   if [ "$search" ]; then
      search=$(echo $search | sed -r 's/.*\.g\s*//');
      say "result: $( curl -s --get --data-urlencode "q=$search" http://ajax.googleapis.com/ajax/services/search/web?v=1.0 | sed 's/"unescapedUrl":"\([^"]*\).*/\1/;s/.*GwebSearch",//')";
   fi
   
   topic=$(tail out | grep -P '<.*>\s*\.t\s*.*');
   if [ "$topic" ]; then
      topic=$(echo $topic | sed -r 's/.*\.t\s*//');
      echo "/t Intern Appreciation Chat: $topic"
   fi
   
   date=$(tail out | grep -P '<.*>\s*\.date\s*.*');
   if [ "$date" ]; then
      args=$(echo $date | sed -r 's/.*\.date\s*(.*)/\1/')
      say "$(date | head -c 180)"
   fi
   
   cal=$(tail out | grep -P '<.*>\s*\.cal\s*.*');
   if [ "$cal" ]; then
      args=$(echo $cal | sed -r 's/.*\.cal\s*(.*)/\1/')
      say "$(cal | head -c 180)"
   fi

	echo -n > out; 
	sleep .5;
done;
