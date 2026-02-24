unit VpisUkrep;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,ukrepi;

type
  TFvpisUkrep = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ListBox1: TListBox;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    Label3: TLabel;
    procedure ListBox1Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
  private
    { Private declarations }
  public
    Function izbor(imekar :string) : string ;
  end;

var
  FvpisUkrep: TFvpisUkrep;

implementation

{$R *.dfm}




procedure TFvpisUkrep.Edit1Change(Sender: TObject);
begin
  button1.Enabled := true ;
end;

Function TfVpisUkrep.izbor(imekar :string) : string ;
  var ii : integer ;
      listuk : TstringList ;
begin
  label3.Caption := imekar ;
  listuk := TstringList.create ;
  FUkrepi.Getukrepi(listuk) ;
  listbox1.Items := Listuk ;
  ListBox1.Items.Add('Drugo') ;
  ShowModal ;
  listuk.Free ;
  if modalResult = mrOk then
  begin
    ii := listbox1.ItemIndex ;
    if ii >= 0 then
    begin
      if ii = listbox1.Count-1 then result := edit1.Text
                               else result := Listbox1.Items[ii]
    end else result := '' ;
  end else result := '' ;
end;

procedure TFvpisUkrep.ListBox1Click(Sender: TObject);
  var ii,kk : Integer ;
begin
  ii := ListBox1.ItemIndex ;
  kk := ListBox1.Items.Count ;
  if ii = kk-1 then
  begin
    edit1.text := '' ;
    label2.Visible := true ;
    edit1.Visible := true ;
  end else
  begin
    label2.Visible := false ;
    edit1.Visible := false ;
    button1.Enabled := true ;
  end;

end;

end.
