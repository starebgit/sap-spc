unit VpisOpom;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.ExtCtrls, sap, VpisUkrep, deklar,
  Vcl.StdCtrls ;

type
  TFvpisOpom = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Grid1: TStringGrid;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    Procedure Vpis(var evalList : Tlist) ;
  end;

var
  FvpisOpom: TFvpisOpom;

implementation

{$R *.dfm}

procedure TFvpisOpom.Button1Click(Sender: TObject);
begin
  Grid1.Cells[2,grid1.Row] := FVpisUkrep.Izbor('') ;
  button3.Enabled := true ;
end;

procedure TFvpisOpom.Button2Click(Sender: TObject);
  var izb : string ;
  i: Integer;
begin
  izb := FVpisUkrep.Izbor('') ;
  for i := 1 to grid1.RowCount-1 do
  begin
    grid1.Cells[2,i] := izb ;
  end;
  button3.Enabled := true ;
end;

Procedure TFVpisOpom.Vpis(var evalList : Tlist) ;
  var i,j : integer ;
      px : ^evaluac ;
      rw : integer ;
      izb,stk : string ;
begin
  Grid1.ColWidths[2] := 400 ;
  Grid1.ColWidths[0] := 60 ;
  grid1.RowCount := 2 ;
  grid1.Cells[0,0] := 'Št. kar.' ;
  grid1.Cells[1,0] := 'Naziv karakteristike' ;
  grid1.Cells[2,0] := 'Ukrep' ;
  rw := 1 ;
  grid1.FixedColor := $02FFC0C0 ;
  for i := 0 to evalList.count-1 do
  begin
    px := evalList[i] ;
    if px^.ev = 'R' then
    begin
      inc(rw) ;
      grid1.RowCount := rw ;
      grid1.Cells[1,rw-1] := px^.imekar ;
      grid1.Cells[0,rw-1] := px^.stkar ;
      grid1.Cells[2,rw-1] := '' ;
    end;
  end;
  if rw > 1 then showModal ;
  if modalResult = mrOk then
  begin
    for i := 1 to grid1.RowCount-1 do
    begin
      izb := grid1.Cells[2,i] ;
      if izb <> '' then
      begin
        stk := grid1.Cells[0,i] ;
        for j := 0 to evalList.count-1 do
        begin
          px := evalList[j] ;
          if px^.stkar = stk then px^.op := izb
       end;
     end;
    end;
  end;
  button3.Enabled := false ;
end;

end.
