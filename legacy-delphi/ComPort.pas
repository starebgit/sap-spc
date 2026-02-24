unit ComPort;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.strUtils,System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, CPort, System.SyncObjs;

type
   merkanal = record
    kanal : Integer ;
    stmeritev : integer ;
    posebnost : boolean ;
  end ;
  TFcomPort = class(TForm)
    ComPort1: TComPort;
    procedure ComPort1RxChar(Sender: TObject; Count: Integer);
  private
    xx : single ;
    procedure obdeli(str : string) ;
  public
    function preberi(stk: integer; cm : string) : single ;
    function odpri(cm: string) : string ;
    procedure preberi2(row,col,std: integer; cm : string; listk : tlist) ;
    procedure preberi4(row,col,std: integer; cm : string; listk : tlist) ;
    function preberi3(uk: string) : string   ;
    Procedure prekini(cm : String;zapri : boolean) ;
    Procedure pisi(cm : String) ;
  end;

var
  FcomPort: TFcomPort;

implementation

{$R *.dfm}
uses zacetna ;

procedure TFcomPort.ComPort1RxChar(Sender: TObject; Count: Integer);
  var str,stt : string ;
      poz1,poz2 : integer ;
begin
   //ShowMessage('1') ;
  // ComPort1.ReadStr(Str, Count);
  //Obdeli(str) ;
end ;

procedure TFComPort.obdeli(str : string) ;
  var stt : string ;
      poz1,poz2 : integer ;
begin
  // ShowMessage(str) ;
   poz1 := pos(',',str) ;
  // ShowMessage(str +'/'+IntTostr(poz1)) ;
   if poz1 > 0 then
   begin
     str := copy(str,poz1+1,100) ;
    // ShowMessage(str) ;
     poz2 := pos(',',str) ;
   //  ShowMessage(str +'/'+IntTostr(poz2)) ;
     if poz2 > 0 then
     begin
       str := copy(str,1,poz2-1) ;
       stt := replaceStr(str,'.',',') ;
       while ((Pos(' ' ,stt) > 0) and (Length(stt) > 0)) do
       begin
         Delete(stt, Pos(' ', stt), 1);
       end;

       //ShowMessage(stt) ;
       try
         xx := StrToFloat(stt) ;
       except
         xx := 999999
       end;
     end else
       xx := 9999
   end else xx := 9999;
end;

function TFComPort.preberi(stk: integer; cm : string) : single ;
  var str : string ;
      cc : Integer ;
begin
  xx := -9999 ;
  ComPort1.Port := cm ;
 // ShowMessage(comPort1.Port) ;
  ComPort1.Open;
  str := '10' + IntTostr(stk)  + '1100001001' + #13 ;

  ComPort1.WriteStr(Str);
  sleep(500) ;
  cc := 50 ;
  ComPort1.ReadStr(Str, cc);
 // ShowMessage(str) ;
  Obdeli(str) ;
  result := xx ;
  ComPort1.Close;
end;

function TFComPort.odpri(cm : string) : string ;
  var str : string ;
      cc : Integer ;
      Event: TEvent;
      Events: TComEvents;
      step : Integer ;
      answer,data : string ;
      ll,ii : integer ;

  function CtrlHandler(CtrlType: LongWord): Boolean;
  begin
    Event.SetEvent;
    Result := True;
  end;
begin
  Event := TEvent.Create(nil, True, False, '');
  SetConsoleCtrlHandler(@CtrlHandler, True);
  xx := -9999 ;
  ComPort1.Port := cm ;
  // ShowMessage(comPort1.Port) ;

   ComPort1.Events := [];

   ComPort1.FlowControl.ControlDTR := dtrEnable;
   ComPort1.FlowControl.ControlRTS := rtsEnable;
   ComPort1.Open; // open port

   data := '' ;
   Events := [evRxChar] ;
   ComPort1.WaitForEvent(Events, Event.Handle, 10000);  // wait for charachters
   if evRxChar in Events then
   begin
          //  ComPort1.ReadStr(Data, ComPort1.InputCount);
     sleep(300)  ;
     ComPort1.ReadStr(data, 100);
   end else ShowMessage('Konec èakanja') ;

   showMessage(data) ;
   result := data ;

   Event.Free;
   ComPort1.Close;
end;


procedure TFComPort.preberi2(row,col,std: integer; cm : string; listk : tlist) ;
var
  ComPort: TComPort;
  Events: TComEvents;
  Answer, Data, str: string;
  Step: Integer;
  Event: TEvent;
  stmer : string ;
  ii : integer ;
  pp : ^MerKanal ;
  stm,stk : Integer ;

  function CtrlHandler(CtrlType: LongWord): Boolean;
  begin
    Event.SetEvent;
    Result := True;
  end;

begin
  xx := -9999 ;
  Event := TEvent.Create(nil, True, False, '');
  SetConsoleCtrlHandler(@CtrlHandler, True);
  for ii := 0 to listk.count-1 do
  begin
    pp := listk[ii] ;
    stm := pp^.stmeritev ;
    stk := pp^.kanal ;
    if stk > 8 then
    begin
      row := row + stm ;
      continue ;
    end ;
    stmer := Format('%3.3d',[stm]) ;
    str := '20' + IntTostr(stk)  + '1103001' + stmer +  #13 ;

    try
      ComPort1.Port := cm ;
      ComPort1.Events := [];

      ComPort1.FlowControl.ControlDTR := dtrEnable;
      ComPort1.FlowControl.ControlRTS := rtsEnable;
      ComPort1.Open; // open port
      ComPort1.WriteStr(Str);
      sleep(300) ;

      Answer := '';
      step := 0;
      repeat
        Events := [evRxChar] ;
        ComPort1.WaitForEvent(Events, Event.Handle, 120000);  // wait for charachters
        if evRxChar in Events then
        begin
          //  ComPort1.ReadStr(Data, ComPort1.InputCount);
          sleep(300)  ;
          ComPort1.ReadStr(data, 250);
          Answer := Data;
          Obdeli(answer) ;
          Fzacetna.karakti.Cells[col,row] := FloatTostrF(xx,ffFixed,10,std) ;
         // fzacetna.edit3.text := IntTostr(stm) + '/' + IntTostr(listk.Count-1) ;
          Fzacetna.refresh ;
          row := row + 1 ;
         // showMessage('answer') ;
        end else ShowMessage('Konec èakanja') ;
        sleep(300) ;
        Inc(Step)
      until (Events = []) or (Step = stm);
    except
      on E: Exception do
      WriteLn('Error: ' + E.Message);
    end;
  end ;
  Event.Free;
  ComPort1.Close;
end;

function TFComPort.preberi3(uk: string) : string   ;
var
  ComPort: TComPort;
  Events: TComEvents;
  Answer, Data, str: string;
  Step: Integer;
  Event: TEvent;
  stmer : string ;
  ii : integer ;
  pp : ^MerKanal ;
  stm,stk : Integer ;

  function CtrlHandler(CtrlType: LongWord): Boolean;
  begin
    Event.SetEvent;
    Result := True;
  end;

begin
  xx := -9999 ;
  Event := TEvent.Create(nil, True, False, '');
  SetConsoleCtrlHandler(@CtrlHandler, True);


    str := uk  +  #13  + #10;

    try
      ComPort1.Port := 'COM3' ;
      ComPort1.Events := [];

      ComPort1.FlowControl.ControlDTR := dtrEnable;
      ComPort1.FlowControl.ControlRTS := rtsEnable;
      ComPort1.Open; // open port
      ComPort1.WriteStr(Str);
    //  sleep(300) ;

      Answer := '';
      step := 0;
     // repeat
        Events := [evRxChar] ;
        ComPort1.WaitForEvent(Events, Event.Handle, 120000);  // wait for charachters
        if evRxChar in Events then
        begin
          //  ComPort1.ReadStr(Data, ComPort1.InputCount);
       //   sleep(300)  ;
          ComPort1.ReadStr(data, 500);
          Answer := Answer + Trim(Data);
         // Obdeli(answer) ;
        //  Fzacetna.karakti.Cells[col,row] := FloatTostrF(xx,ffFixed,10,std) ;
        //  Fzacetna.refresh ;
        //  row := row + 1 ;
         // showMessage('answer') ;
        end ; //else ShowMessage('Konec èakanja') ;
        sleep(300) ;
        Inc(Step) ;
    // until (Events = []) or (Step = 10);
      SHowmessage(answer) ;
    except
      on E: Exception do
      WriteLn('Error: ' + E.Message);
    end;
   result := answer ;
  Event.Free;
  ComPort1.Close;
end;

procedure TFComPort.preberi4(row,col,std: integer; cm : string; listk : tlist) ;
var
  ComPort: TComPort;
  Events: TComEvents;
  Answer, Data, str: string;
  Step: Integer;
  Event: TEvent;
  stmer : string ;
  ii,kk : integer ;
  pp : ^MerKanal ;
  stm,stk : Integer ;
  listamaxMin : TstringList ;
  min,max : single ;
  rsb : boolean ;
  rw : integer ;

  function CtrlHandler(CtrlType: LongWord): Boolean;
  begin
    Event.SetEvent;
    Result := True;
  end;

begin
  xx := -9999 ;
  Event := TEvent.Create(nil, True, False, '');
  SetConsoleCtrlHandler(@CtrlHandler, True);
  listaMaxMin := TstringList.Create ;

   ComPort1.Port := cm ;
   ComPort1.Events := [];
   ComPort1.FlowControl.ControlDTR := dtrEnable;
   ComPort1.FlowControl.ControlRTS := rtsEnable;
   ComPort1.Open; // open port


  for ii := 0 to listk.count-1 do
  begin
    pp := listk[ii] ;
    stm := pp^.stmeritev ;
    stk := pp^.kanal ;
    stmer := Format('%3.3d',[stm]) ;
    str := '20' + IntTostr(stk)  + '1103001' + stmer +  #13 ;
    Fzacetna.psb := pp^.posebnost ;
    {if pp^.posebnost then
    begin
       Fzacetna.Button14.Visible := true ;
       Fzacetna.refresh ;
    end ;     }
    rsb := false ;

    repeat
      try
       { ComPort1.Port := cm ;
        ComPort1.Events := [];

        ComPort1.FlowControl.ControlDTR := dtrEnable;
        ComPort1.FlowControl.ControlRTS := rtsEnable;
        ComPort1.Open; // open port     }
        ComPort1.WriteStr(Str);
        //sleep(300) ;
        //showMessage('a'+ IntTostr(ii)) ;
        Answer := '';
        data := '' ;
        step := 0;
        repeat
          Events := [evRxChar] ;
          ComPort1.WaitForEvent(Events, Event.Handle, 300000);  // wait for charachters
          fzacetna.Edit4.text := '' ;
         // showMessage('b'+ IntTostr(ii)) ;
          if evRxChar in Events then
          begin
            sleep(300)  ;

            ComPort1.ReadStr(data, 250);
            Answer := Data;
            Obdeli(answer) ;

            if not fzacetna.psb then
            begin
              Fzacetna.karakti.Cells[col,row] := FloatTostrF(xx,ffFixed,10,std) ;
             // fzacetna.button14.enabled := false ;
              Fzacetna.refresh ;
              fzacetna.Edit4.text := data;
              row := row + 1 ;
            end else
            begin
           //   fzacetna.button14.enabled := true ;
              if xx < 900 then  listaMaxMin.add(FloatTostrF(xx,ffFixed,10,std)) ;
              fzacetna.Edit3.text := FloatTostrF(xx,ffFixed,10,std) ;
              fzacetna.Edit4.text := data;
              if not rsb  then rw := row ;
              rsb := true ;
            end;

          end else
          begin
             Fzacetna.karakti.Cells[col,row] := IntTostr(stm) ;
             Fzacetna.refresh ;
             row := row + 1
          end;
          sleep(300) ;
          Inc(Step)
        until (Events = []) or (Step = stm);
      except
        on E: Exception do
        WriteLn('Error: ' + E.Message);
      end;
    until not fzacetna.psb ;
    // fzacetna.Edit2.text := IntTostr(listamaxmin.Count) ;
    if rsb  then
    begin
      min := 999 ;
      max := -999 ;
      for kk := 0 to listamaxMin.count-1 do
      begin
        xx := StrTofloat(listamaxMin[kk]) ;
        if xx < min then min := xx ;
        if xx > max then max := xx ;
      end ;
      Fzacetna.karakti.Cells[col,rw] := FloatTostrF(min,ffFixed,10,std) ;
      Fzacetna.karakti.Cells[col,rw+1] := FloatTostrF(max,ffFixed,10,std) ;
      sleep(100) ;
      Fzacetna.refresh ;
      row := rw + 2 ;
    end ;
  end ;     // konec pregled po listi
  Event.Free;

  ListamaxMin.Free ;
  ComPort1.Close;
end;


Procedure TFcomport.prekini(cm : String;zapri : boolean) ;
  var str : string ;
begin
  try
    ComPort1.Port := cm ;
    ComPort1.Events := [];

    str := '1011100001001' +  #13 ;

    ComPort1.FlowControl.ControlDTR := dtrEnable;
    ComPort1.FlowControl.ControlRTS := rtsEnable;
   //ComPort1.Open; // open port
    ComPort1.WriteStr(Str);
   if zapri then  ComPort1.close ;
  except
     ShowMessage('com port ni bil odprt') ;
  end;
end;

Procedure TFcomport.pisi(cm : String) ;
  var str : string ;
begin
  ComPort1.Port := cm ;
  ComPort1.Events := [];

  str := '1011100001001' +  #13 ;

  ComPort1.FlowControl.ControlDTR := dtrEnable;
  ComPort1.FlowControl.ControlRTS := rtsEnable;
 //ComPort1.Open; // open port
  ComPort1.WriteStr(Str);
  ComPort1.WriteStr(Str);

end;



end.
