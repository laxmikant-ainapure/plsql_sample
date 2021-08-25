create or replace
function get_price_segment(p_film_id integer) returns VARCHAR(50) as $ $ declare rate numeric;

price_segment VARCHAR(50);

begin
-- get the rate based on film_id
 select
		into	rate rental_rate
from	film
where	film_id = p_film_id;

case
	rate when 0.99 then price_segment = 'Mass';
when 2.99 then price_segment = 'Mainstream';
when 4.99 then price_segment = 'High End';
else price_segment = 'Unspecified';
end
case ;

	return price_segment;
end;

$ $ language plpgsql;