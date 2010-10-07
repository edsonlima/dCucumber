(*
 * The contents of this file are subject to the Mozilla Public
 * License Version 1.1 (the "License"); you may not use this file
 * except in compliance with the License. You may obtain a copy of
 * the License at http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS
 * IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
 * implied. See the License for the specific language governing
 * rights and limitations under the License.
 *
 * Contributor(s):
 * Jody Dawkins <jdawkins@delphixtreme.com>
 *)

unit dSpecUtils;

interface

function CallerAddr: Pointer; assembler;
function GetImplementingObjectFor(AInterface : IInterface) : TObject;
function IsNumeric(const s : string) : Boolean;
function IsAlpha(const s : string) : Boolean;
function IsAlphaNumeric(const s : string) : Boolean;
function IsPrime(N: Integer): Boolean;
function GetValueName(Value : Variant; const PreferredName : string) : string;

implementation

uses Variants;

function IsBadPointer(P: Pointer):boolean; register;
begin
  try
    Result  := (p = nil)
              or ((Pointer(P^) <> P) and (Pointer(P^) = P));
  except
    Result := true;
  end
end;

function CallerAddr: Pointer; assembler;
{
  This code is straight from the DUnit souce.
  TestFramework.pas
}
const
  CallerIP = $4;
asm
   mov   eax, ebp
   call  IsBadPointer
   test  eax,eax
   jne   @@Error

   mov   eax, [ebp].CallerIP
   sub   eax, 5   // 5 bytes for call

   push  eax
   call  IsBadPointer
   test  eax,eax
   pop   eax
   je    @@Finish

@@Error:
   xor eax, eax
@@Finish:
end;

function GetImplementingObjectFor(AInterface : IInterface) : TObject;
{
  This code is straight from Chee Wee's productivity experts.
  WelcomePageIntf.pas
}
const
  AddByte = $04244483;
  AddLong = $04244481;
type
  PAdjustSelfThunk = ^TAdjustSelfThunk;
  TAdjustSelfThunk = packed record
    case AddInstruction: longint of
      AddByte : (AdjustmentByte: shortint);
      AddLong : (AdjustmentLong: longint);
  end;
  PInterfaceMT = ^TInterfaceMT;
  TInterfaceMT = packed record
    QueryInterfaceThunk: PAdjustSelfThunk;
  end;
  TInterfaceRef = ^PInterfaceMT;
var
  QueryInterfaceThunk: PAdjustSelfThunk;
begin
  Result := Pointer(AInterface);
  if Assigned(Result) then
    try
      QueryInterfaceThunk := TInterfaceRef(AInterface)^. QueryInterfaceThunk;
      case QueryInterfaceThunk.AddInstruction of
        AddByte: Inc(PChar(Result), QueryInterfaceThunk.AdjustmentByte);
        AddLong: Inc(PChar(Result), QueryInterfaceThunk.AdjustmentLong);
      else
        Result := nil;
      end;
    except
      Result := nil;
    end;
end;

function IsNumeric(const s : string) : Boolean;
var
  c: Integer;
begin
  Result := False;
  for c := 1 to Length(s) do
    if not (s[c] in ['0'..'9']) then
      Exit;
  Result := True;
end;

function IsAlpha(const s : string) : Boolean;
var
  c: Integer;
begin
  Result := False;
  for c := 1 to Length(s) do
    if not (s[c] in [' '..'/', 'A'..'Z', 'a'..'z']) then
      Exit;
  Result := True;
end;

function IsAlphaNumeric(const s : string) : Boolean;
var
  c: Integer;
begin
  Result := False;
  for c := 1 to Length(s) do
    if not (s[c] in [' '..'/', '0'..'9', 'A'..'Z', 'a'..'z']) then
      Exit;
  Result := True;
end;

function IsPrime(N: Integer): Boolean;
var
  Z: Real;
  Max: LongInt;
  Divisor: LongInt;
begin
  Result := False;
  if (N and 1) = 0 then Exit;
  Z := Sqrt(N);
  Max := Trunc(Z) + 1;
  Divisor := 3;
  while Max > Divisor do begin
    if (N mod Divisor) = 0 then
      Exit;
    Inc(Divisor, 2);
    if (N mod Divisor) = 0 then
      Exit;
    Inc(Divisor, 4);
  end;
  Result := True;
end;

function GetValueName(Value : Variant; const PreferredName : string) : string;
var
  DataType: TVarType;
begin
  if PreferredName <> '' then begin
    Result := PreferredName;
    Exit;
  end;
  DataType := VarType(Value);
  Result := VarTypeAsText(DataType);
end;

end.
