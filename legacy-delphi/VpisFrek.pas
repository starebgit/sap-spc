unit VpisFrek;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TFvpisFrek = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Button1: TButton;
    Button2: TButton;
  private
    { Private declarations }
  public
    Procedure vpis(var frk,trj : integer) ;
  end;

var
  FvpisFrek: TFvpisFrek;

implementation

{$R *.dfm}

Procedure TFVpisFrek.Vpis(var frk,trj : integer) ;
begin
  edit1.Text := IntTostr(frk) ;
  edit2.Text := IntTostr(trj) ;
  ShowModal ;
  if modalResult = mrOk then
  begin
    frk := strToIntDef(edit1.text,0) ;
    trj := strToIntDef(edit2.text,0)
  end else
  begin
    frk := 0 ;
    trj := 0 ;
  end;


end;

end.
