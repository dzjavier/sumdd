unit Colocalization;


{This library has the implementation of various colocalization algorithms}


interface

uses Math;

procedure PearsonCorrelationCoeficient(const S1,S2:array of double; var Rr:double);

procedure OverlapCoeficient(const S1,S2:array of double; var R:double);

procedure OverlapCoeficientK1(const S1,S2:array of double; var K1:double);

procedure OverlapCoeficientK2(const S1,S2:array of double; var K2:double);

procedure ColocalizationCoeficientsMm1Mm2(const S1,S2:array of double; var Mm1,Mm2:double);

procedure ColocalizationCoeficientsM1M2(const S1,S2:array of double; var M1,M2:double;
                                        const MinS1,MaxS1,MinS2,MaxS2:double);



implementation
procedure PearsonCorrelationCoeficient(const S1,S2:array of double; var Rr:double);

 var
  j:integer;
  Aux1,Aux2:double;
  VecAux1,VecAux2:array of double;
 begin
  if not (Length(S1) = length(S2)) then
   begin
    Exit;
   end; 
 SetLength(VecAux1,Length(S1));
 SetLength(VecAux2,Length(S2));
 Aux1:=Mean(S1); Aux2:=Mean(S2);
 
 for j:= Low(S1) to High(S1) do
  begin
   VecAux1[j]:=S1[j]-Aux1;
   VecAux2[j]:=S2[j]-Aux2;
  end;  
 Aux1:=SumOfSquares(VecAux1); 
 Aux2:=SumOfSquares(VecAux2);
 Aux1:=sqrt(Aux1*Aux2);
 Aux2:=0.0;
 for j:= Low(S1) to High(S1) do
  begin
   Aux2:=Aux2+(VecAux1[j]*VecAux2[j]);
  end;   
 Rr:=Aux2/Aux1;
  
end;
procedure OverlapCoeficient(const S1,S2:array of double; var R:double);
 var
  j:integer;
  Aux1,Aux2:double;
  
 begin
  if not (Length(S1) = length(S2)) then
   begin
    Exit;
   end; 
 Aux1:=SumOfSquares(S1);
 Aux2:=SumOfSquares(S2);
 Aux1:=sqrt(Aux1*Aux2);
 Aux2:=0.0;
 for j:= Low(S1) to High(S1) do
  begin
   Aux2:=Aux2+(S1[j]*S2[j]);
  end;   
 R:=Aux2/Aux1;
 end;
procedure OverlapCoeficientK1(const S1,S2:array of double; var K1:double);
var
  j:integer;
  Aux1,Aux2:double;
  
 begin
  if not (Length(S1) = length(S2)) then
   begin
    Exit;
   end; 
 Aux1:=SumOfSquares(S1); 
 Aux2:=0.0;
 for j:= Low(S1) to High(S1) do
  begin
   Aux2:=Aux2+(S1[j]*S2[j]);
  end;   
 K1:=Aux2/Aux1;
 end;
procedure OverlapCoeficientK2(const S1,S2:array of double; var K2:double);
 var
  j:integer;
  Aux1,Aux2:double;

 begin
  if not (Length(S1) = length(S2)) then
   begin
    Exit;
   end;
 Aux1:=SumOfSquares(S2);
 Aux2:=0.0;
 for j:= Low(S1) to High(S1) do
  begin
   Aux2:=Aux2+(S1[j]*S2[j]);
  end;
  K2:=Aux2/Aux1;
 end;

procedure ColocalizationCoeficientsMm1Mm2(const S1,S2:array of double; var Mm1,Mm2:double);
 var
  j:integer;
  VecAux1,VecAux2:array of double;
 begin
  if not (Length(S1) = length(S2)) then
   begin
    Exit;
   end;
 SetLength(VecAux1,Length(S1));
 SetLength(VecAux2,Length(S2));

 for j:= Low(S1) to High(S1) do
  begin
   if not(S2[j]=0) then   VecAux1[j]:=S1[j]
    else VecAux1[j]:=0;
   if not(S1[j]=0) then   VecAux2[j]:=S2[j]
    else VecAux2[j]:=0;
  end;
 Mm1:=Sum(VecAux1)/Sum(S1);
 Mm2:=Sum(VecAux2)/Sum(S2);
end;

procedure ColocalizationCoeficientsM1M2(const S1,S2:array of double; var M1,M2:double;
                                        const MinS1,MaxS1,MinS2,MaxS2:double);
var
 SumS1,SumS2:double;
 j:integer;
begin
 if Length(S1) = Length(S2) then
  begin
   SumS1:=Sum(S1);
   SumS2:=Sum(S2);
   M1:=0; M2:=0;
   for j:= Low(S1) to High(S1) do
    begin
     if (S1[j] <= MaxS2) and (S1[j]>=MinS2) then M1:= M1 + S1[j];
     if (S2[j] <= MaxS1) and (S2[j]>=MinS1) then M2:= M2 + S2[j];
    end;
    M1:=M1/Sums1;
    M2:=M2/SumS2;
  end;
end;
end.
