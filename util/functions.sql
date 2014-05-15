-- ---------------------------------------------------------------------
-- converts mapnik's !scale_denominator! param to web mercator z
CREATE OR REPLACE FUNCTION public.z(scaledenominator numeric)
 RETURNS integer
 LANGUAGE plpgsql IMMUTABLE
AS $function$
begin
    -- Don't bother if the scale is larger than ~zoom level 0
    if scaledenominator > 600000000 then
        return null;
    end if;
    return round(log(2,559082264.028/scaledenominator));
end;
$function$;
