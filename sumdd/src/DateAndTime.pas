unit DateAndTime;

interface
uses
 SysUtils,// Date and Time methods
 DateUtils; // DayOfThe... methods
type
 DateTime=class
 public
  function getDateTimeISO8601:AnsiString;
 private
  function FirstLetterOfTheDay(const number_of_the_day:Word):AnsiChar;
end;
implementation
function   DateTime.getDateTimeISO8601:AnsiString;
var
 date_str,time_str: AnsiString;
 date_aux:TDateTime;
 time_aux:TDateTime;
begin
 date_aux:=Date;
 time_aux:=Time;
// DateTimeToString(date_str,'yyyy-mm-dd',date_aux);
 date_str:=date_str+FirstLetterOfTheDay(DayOfTheWeek(date_aux));
// DateTimeToString(time_str,'hh:nn:ss',time_aux);
 Result:=date_str+time_str;
end;
function DateTime.FirstLetterOfTheDay(const number_of_the_day: Word):AnsiChar;
begin
case number_of_the_day of
 1: Result:='M';
 2: Result:='T';
 3: Result:='W';
 4: Result:='T';
 5: Result:='F';
 6: Result:='S';
 7: Result:='S';
end;

end;
end.
