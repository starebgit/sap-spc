unit defAnaliza;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TFDefAnaliza = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Picker1: TDateTimePicker;
    Picker2: TDateTimePicker;
    Button1: TButton;
    Button2: TButton;
  private
    { Private declarations }
  public
    Procedure defi(var dat1,dat2 : TdateTime) ;
  end;

var
  FDefAnaliza: TFDefAnaliza;

implementation

{$R *.dfm}

Procedure TFDefAnaliza.defi(var dat1,dat2 : TdateTime) ;
begin
  picker1.Date := date -30 ;
  picker2.date := date ;
  ShowModal ;
  if modalResult = mrOk then
  begin
    picker1.Time := StrToTime('00:00:00') ;
    picker2.Time := StrToTime('23:59:59') ;
    dat1 := picker1.date ;
    dat2 := picker2.date ;
  end;

end;

end.
