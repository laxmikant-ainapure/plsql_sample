create or replace
function get_freq_table_general(col VARCHAR,
tablName VARCHAR) returns table( name VARCHAR,
frequency INT,
total_frequency INT,
relative_frequency numeric,
sum_relative_frequency numeric ) as $$ begin return QUERY execute '
    WITH a as (
      SELECT DISTINCT ' || col || ' as colName, count(*) OVER (PARTITION BY ' || col || ') as freq , 
      count(*) OVER() as total_freq FROM ' || tablName || '),b as(SELECT a.colName,a.freq, a.total_freq,round((a.freq::numeric/a.total_freq::numeric),2::integer) as relative_freq FROM a)SELECT b.colName::VARCHAR, b.freq::INT, b.total_freq::INT,b.relative_freq::NUMERIC,sum(b.relative_freq) OVER(ORDER BY b.relative_freq)::NUMERIC as suma_rel_freq
      FROM b';
end;

$$ language 'plpgsql'