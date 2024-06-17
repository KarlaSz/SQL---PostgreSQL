--IF
CREATE OR REPLACE FUNCTION get_varranty_status(p_start DATE, p_end DATE)
RETURNS TEXT AS $$
DECLARE
	comment TEXT := '';
	today DATE := CURRENT_DATE;
BEGIN
	--po slowie if trzem aokreslic warunek
	IF p_start>today THEN
		comment := 'NOT VALID - IN FUTURE';
	ELSEIF p_end<today THEN
		comment := 'NOT VALID - IN PAST';
	ELSE
		comment := 'VALID';
	END IF;
	--end if konczymy isntrukcje warunkowe if
    RETURN comment;
END;
$$ LANGUAGE PLPGSQL;

SELECT get_varranty_status(start_date, end_date), * FROM varranty

--CASE - stosujemy gdy za duzo ifow else

CREATE OR REPLACE FUNCTION fn_get_weekend1(p_day timestamp) RETURNS VARCHAR(20) AS
$$
DECLARE
	dow INT = 0;
BEGIN
	SELECT extract(isodow FROM p_day) INTO dow;
	--za case okreslamu  jaka zmienna decyduje co ma sie dalej dziac
	CASE dow
		WHEN 1 THEN RETURN 'Sunday';
		WHEN 6 THEN RETURN 'Friday';
		WHEN 7 THEN RETURN 'Satruday';
		ELSE RETURN 'week day';
	END CASE;
END;
$$ LANGUAGE PLPGSQL;

SELECT fn_get_weekend1('2022-07-08'), fn_get_weekend1('2022-07-09'), fn_get_weekend1('2022-07-11')

--petla for do przetwazania danych skroconych przez inne zapytanie
--przedluzanie gwarancji
CREATE OR REPLACE FUNCTION extend_varranty() RETURNS SETOF varranty AS
$$
DECLARE
	v RECORD;
BEGIN
	FOR v IN SELECT * FROM varranty
	LOOP
	CONTINUE WHEN v.end_date < CURRENT_DATE + INTERVAL '1 year';
		IF v.start_date >= CURRENT_DATE THEN
			v.end_date := v.end_date + INTERVAL '1 year';
		ELSEIF v.end_date >= CURRENT_DATE THEN
				v.end_date := v.end_date + INTERVAL '6 months';
		END IF;
		RETURN NEXT v;
	END LOOP;
	
	--jesli funkcja cos zworic to przyjmuje wartosc true,a jesli nic to wtedy jest false
	IF NOT FOUND THEN
		RAISE EXCEPTION 'No varranties found';
		END IF;
	RETURN;
	END;
$$ LANGUAGE PLPGSQL;

SELECT 'OLD', varranty_id, start_date, end_date FROM varranty
UNION ALL
SELECT 'NEW', varranty_id, start_date, end_date FROM extend_varranty()
ORDER BY 2,1