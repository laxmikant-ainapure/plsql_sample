begin
    for film_data in select id,title 
	       from film 
	       order by length desc, title
	       limit 10   loop 
        for a in select actor_name from actors where actors.film_id=film_data.id loop
            raise notice 'film name=% , actor name=%', film_data.title, a.actor_name;
        end loop;
    end loop;
end;
