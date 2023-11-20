unit USort;

interface
 
uses
 DecTypes;

procedure QSort(var Vector: array of Double); //recursive

procedure QSortNR(var Vector: TVector); // no recursive
var
  Stack: array [0..2000000]of Integer; //array [0..1073741822]of Integer;

implementation

procedure QSortNR(var Vector: TVector);

procedure Sort(var A: TVector; iLo, iHi: Integer);
 var
  L,R: integer;
  Mid:Double;
  Temp:Double;

  SP:Integer;
 begin
  Stack[0]:=iLo;
  Stack[1]:=iHi;
  SP:= 2;
  while (SP<>0) do
	begin
	 dec(SP,2);
	 iLo:=Stack[SP];
	 iHi:=Stack[SP+1];
	 while (iLo < iHi ) do							
	  begin
	   Mid:= A[(iLo+iHi) div 2];
	   L:=pred(iLo);
	   R:=succ(iHi);
	   while true do 
		begin
		 repeat dec(R); until (A[R] >= Mid); 
		 repeat inc(L); until (A[L] <= Mid); 
		 if (L >= R) then Break;
		 Temp:=A[L];
		 A[L]:=A[R];
		 A[R]:=Temp;
		end;
	   if (R-iLo)<(iHi-R) then
	    begin
	     Stack[SP]:=succ(R);
	     Stack[SP+1]:=iHi;
	     inc(SP,2);
	     iHi:=R;
	    end
	   else
	    begin
	     Stack[SP]:=iLo;
	     Stack[SP+1]:= R;
	     inc(SP,2);
	     iLo:=succ(R);
	    end; 
	  end;
	end;  
 end;

begin
 Sort(Vector, Low(Vector), High(Vector));
end; 

procedure QSort(var Vector: array of Double); //recursive

 procedure Sort(var A: Array of Double; iLo, iHi: Integer);
  // quick sort (recursive) // It sorts from Highest to Lowest
  var
    Lo, Hi: Integer; // indexes
    Mid: Double; // counter values
    T: Double;
  begin
    Lo := iLo;
    Hi := iHi;
    Mid := A[(Lo + Hi) div 2];
    repeat
      while A[Lo] > Mid do Inc(Lo);
      while A[Hi] < Mid do Dec(Hi);
      if Lo <= Hi then
      begin
        T := A[Lo];
        A[Lo] := A[Hi];
        A[Hi] := T;
        Inc(Lo);
        Dec(Hi);
      end;
    until Lo > Hi;
    if Hi > iLo then Sort(A, iLo, Hi);
    if Lo < iHi then Sort(A, Lo, iHi);
   end;

 begin
  Sort(Vector, Low(Vector), High(Vector));
 end;										  

end.