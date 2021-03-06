unit _ga3d;

interface

type
  TGA3DObject = class //base
  protected
    function GetElmt( idx: integer ): real; virtual; abstract;
  public
    function add( opd: TGA3DObject ): TGA3DObject; virtual; abstract;
    function sub( opd: TGA3DObject ): TGA3DObject; virtual; abstract;
    function mul( opd: TGA3DObject ): TGA3DObject; virtual; abstract;
    function mag: real; virtual; abstract; //magnitude
    procedure nor; virtual; abstract; //normalize
    procedure rev; virtual; abstract; //reverse
    procedure neg; virtual; abstract; //negation
    property Elmt[idx: integer]: real read GetElmt;
  end;

  TGA3Ds = class( TGA3DObject ) //scalar
  protected
    FValue: real;
    function GetElmt( idx: integer ): real; override;
  public
    constructor Create( value: real = 0 );
    function add( opd: TGA3DObject ): TGA3DObject; override;
    function sub( opd: TGA3DObject ): TGA3DObject; override;
    function mul( opd: TGA3DObject ): TGA3DObject; override;
    function mag: real; override;
    procedure nor; override;
    procedure rev; override;
    procedure neg; override;
  end;

  TGA3Dv = class( TGA3DObject ) //homogenous vector
  protected
    FValue: array[0..2] of real;
    function GetElmt( idx: integer ): real; override;
  public
    constructor Create( e1, e2, e3: real );
    function add( opd: TGA3DObject ): TGA3DObject; override;
    function sub( opd: TGA3DObject ): TGA3DObject; override;
    function mul( opd: TGA3DObject ): TGA3DObject; override;
    function mag: real; override;
    procedure nor; override;
    procedure rev; override;
    procedure neg; override;
  end;

  TGA3Dbv = class( TGA3DObject ) //homogenous vector
  protected
    FValue: array[0..2] of real;
    function GetElmt( idx: integer ): real; override;
  public
    constructor Create( e12, e23, e31: real );
    function add( opd: TGA3DObject ): TGA3DObject; override;
    function sub( opd: TGA3DObject ): TGA3DObject; override;
    function mul( opd: TGA3DObject ): TGA3DObject; override;
    function mag: real; override;
    procedure nor; override;
    procedure rev; override;
    procedure neg; override;
  end;

  TGA3Dtv = class( TGA3DObject ) //pseudoscalar (trivector)
  protected
    FValue: real;
    function GetElmt( idx: integer ): real; override;
  public
    constructor Create( e123: real = 0 );
    function add( opd: TGA3DObject ): TGA3DObject; override;
    function sub( opd: TGA3DObject ): TGA3DObject; override;
    function mul( opd: TGA3DObject ): TGA3DObject; override;
    function mag: real; override;
    procedure nor; override;
    procedure rev; override;
    procedure neg; override;
  end;

  TGA3Dmv = class( TGA3DObject ) //generic multivector
  protected
    FValue: array[0..7] of real;
    function GetElmt( idx: integer ): real; override;
  public
    constructor Create( s, e1, e2, e3, e12, e23, e31, e123: real );
    function add( opd: TGA3DObject ): TGA3DObject; override;
    function sub( opd: TGA3DObject ): TGA3DObject; override;
    function mul( opd: TGA3DObject ): TGA3DObject; override;
    function mag: real; override;
    procedure nor; override;
    procedure rev; override;
    procedure neg; override;
  end;

var
  ga3dI             : tga3dtv;

implementation

{ TGA3Ds }

function TGA3Ds.add( opd: TGA3DObject ): TGA3DObject;
begin
  if opd is tga3ds then begin
    result := tga3ds.Create( FValue + opd.Elmt[0] );
  end
  else begin
    result := tga3dmv.Create(
      FValue + opd.Elmt[0],
      opd.Elmt[1],
      opd.Elmt[2],
      opd.Elmt[3],
      opd.Elmt[4],
      opd.Elmt[5],
      opd.Elmt[6],
      opd.Elmt[7],
      );
  end;
end;

constructor TGA3Ds.Create( value: real );
begin
  FValue := value;
end;

function TGA3Ds.GetElmt( idx: integer ): real;
begin
  if idx = 0 then
    result := fvalue
  else
    result := 0;
end;

function TGA3Ds.mag: real;
begin
  result := abs( fvalue );
end;

function TGA3Ds.mul( opd: TGA3DObject ): TGA3DObject;
begin
  if opd is tga3ds then
    result := tga3ds.Create( fvalue * opd.Elmt[0] )
  else
    if opd is tga3dv then
      result := tga3dv.Create( fvalue * opd.Elmt[1], fvalue * opd.Elmt[2], fvalue * opd.Elmt[3] )
    else
      if opd is tga3dbv then
        result := tga3dbv.Create( fvalue * opd.Elmt[4], fvalue * opd.Elmt[5], fvalue * opd.Elmt[6] )
      else
        if opd is tga3dtv then
          result := tga3dtv.Create( fvalue * opd.Elmt[7] )
        else
          result := tga3dmv.Create(
            fvalue * opd.Elmt[0],
            fvalue * opd.Elmt[1],
            fvalue * opd.Elmt[2],
            fvalue * opd.Elmt[3],
            fvalue * opd.Elmt[4],
            fvalue * opd.Elmt[5],
            fvalue * opd.Elmt[6],
            fvalue * opd.Elmt[7]
            );
end;

procedure TGA3Ds.neg;
begin
  inherited;
  fvalue := -fvalue;
end;

procedure TGA3Ds.nor;
begin
  inherited;
  fvalue := 1;
end;

procedure TGA3Ds.rev;
begin
  inherited;
end;

function TGA3Ds.sub( opd: TGA3DObject ): TGA3DObject;
begin
  if opd is tga3ds then begin
    result := tga3ds.Create( FValue - opd.Elmt[0] );
  end
  else begin
    result := tga3dmv.Create(
      FValue - opd.Elmt[0],
      -opd.Elmt[1],
      -opd.Elmt[2],
      -opd.Elmt[3],
      -opd.Elmt[4],
      -opd.Elmt[5],
      -opd.Elmt[6],
      -opd.Elmt[7],
      );
  end;
end;

{ TGA3Dv }

function TGA3Dv.add( opd: TGA3DObject ): TGA3DObject;
begin
  if opd is tga3ds then
    result := tga3dmv.Create( opd.Elmt[0], fvalue[0], fvalue[1], fvalue[2], 0, 0, 0, 0 )
  else
    if opd is tga3dv then
      result := tga3dv.Create( fvalue[0] + opd.Elmt[1], fvalue[1] + opd.Elmt[2], fvalue[2] + opd.Elmt[3] )
    else
      if opd is tga3dbv then
        result := tga3dmv.Create( 0, fvalue[0], fvalue[1], fvalue[2], opd.Elmt[4], opd.Elmt[5], opd.Elmt[6], 0 )
      else
        if opd is tga3dtv then
          result := tga3dmv.Create( 0, fvalue[0], fvalue[1], fvalue[2], 0, 0, 0, opd.Elmt[7] )
        else
          result := tga3dmv.Create( opd.Elmt[0], fvalue[0] + opd.Elmt[1], fvalue[1] + opd.Elmt[2], fvalue[2] + opd.Elmt[3], opd.Elmt[4], opd.Elmt[5], opd.Elmt[6], opd.Elmt[7] );
end;

constructor TGA3Dv.Create( e1, e2, e3: real );
begin
  fvalue[0] := e1;
  fvalue[1] := e2;
  fvalue[2] := e3;
end;

function TGA3Dv.GetElmt( idx: integer ): real;
begin
  if idx in [1..3] then
    result := fvalue[idx - 1]
  else
    result := 0;
end;

function TGA3Dv.mag: real;
begin
  result := sqrt( fvalue[0] * fvalue[0] + fvalue[1] * fvalue[1] + fvalue[2] * fvalue[2] );
end;

function TGA3Dv.mul( opd: TGA3DObject ): TGA3DObject;
begin
  if opd is tga3ds then
    result := tga3dv.Create( fvalue[0] * opd.Elmt[0], fvalue[1] * opd.Elmt[0], fvalue[2] * opd.Elmt[0] )
  else
    if opd is tga3dv then
      result := tga3dmv.Create( fvalue[0] * opd.Elmt[1] + fvalue[1] * opd.Elmt[2] + fvalue[2] * opd.Elmt[3], //dot product
        0, 0, 0, //vector part
        fvalue[0] * opd.Elmt[2] - fvalue[1] * opd.Elmt[1],
        fvalue[1] * opd.Elmt[3] - fvalue[2] * opd.Elmt[2],
        fvalue[2] * opd.Elmt[1] - fvalue[0] * opd.Elmt[3],
        0
        )
    else
      if opd is tga3dbv then
        result := tga3dmv.Create( 0, //scalar part
          fvalue[2] * opd.Elmt[6],
          fvalue[0] * opd.Elmt[4],
          fvalue[1] * opd.Elmt[5],
          0, 0, 0, //bivector part
          fvalue[0] * opd.Elmt[5] + fvalue[1] * opd.Elmt[6] + fvalue[2] * opd.Elmt[4]
          )
      else
        if opd is tga3dtv then
          result := tga3dbv.Create( fvalue[2] * opd.Elmt[7], fvalue[0] * opd.Elmt[7], fvalue[1] * opd.Elmt[7] )
        else
          result := tga3dmv.Create(
            fvalue[0] * opd.Elmt[1] + fvalue[1] * opd.Elmt[2] + fvalue[2] * opd.Elmt[3], //
            fvalue[2] * opd.Elmt[6],
            fvalue[0] * opd.Elmt[4],
            fvalue[1] * opd.Elmt[5],
            fvalue[2] * opd.Elmt[7], fvalue[0] * opd.Elmt[7], fvalue[1] * opd.Elmt[7],
            fvalue[0] * opd.Elmt[5] + fvalue[1] * opd.Elmt[6] + fvalue[2] * opd.Elmt[4]
            );
end;

procedure TGA3Dv.neg;
begin
  inherited;
  fvalue[0] := -fvalue[0];
  fvalue[1] := -fvalue[1];
  fvalue[2] := -fvalue[2];
end;

procedure TGA3Dv.nor;
var
  len, inv          : real;
begin
  inherited;
  len := mag;
  if len > 1E-3 then begin
    inv := 1.0 / len;
    fvalue[0] := fvalue[0] * inv;
    fvalue[1] := fvalue[1] * inv;
    fvalue[2] := fvalue[2] * inv;
  end;
end;

procedure TGA3Dv.rev;
begin
  inherited;
end;

function TGA3Dv.sub( opd: TGA3DObject ): TGA3DObject;
begin
  if opd is tga3ds then
    result := tga3dmv.Create( -opd.Elmt[0], fvalue[0], fvalue[1], fvalue[2], 0, 0, 0, 0 )
  else
    if opd is tga3dv then
      result := tga3dv.Create( fvalue[0] - opd.Elmt[1], fvalue[1] - opd.Elmt[2], fvalue[2] - opd.Elmt[3] )
    else
      if opd is tga3dbv then
        result := tga3dmv.Create( 0, fvalue[0], fvalue[1], fvalue[2], -opd.Elmt[4], -opd.Elmt[5], -opd.Elmt[6], 0 )
      else
        if opd is tga3dtv then
          result := tga3dmv.Create( 0, fvalue[0], fvalue[1], fvalue[2], 0, 0, 0, -opd.Elmt[7] )
        else
          result := tga3dmv.Create( -opd.Elmt[0], fvalue[0] - opd.Elmt[1], fvalue[1] - opd.Elmt[2], fvalue[2] - opd.Elmt[3], -opd.Elmt[4], -opd.Elmt[5], -opd.Elmt[6], -opd.Elmt[7] );
end;

{ TGA3Dbv }

function TGA3Dbv.add( opd: TGA3DObject ): TGA3DObject;
begin
  if opd is tga3ds then
    result := tga3dmv.Create( opd.Elmt[0], 0, 0, 0, fvalue[0], fvalue[1], fvalue[2], 0 )
  else
    if opd is tga3dv then
      result := tga3dmv.Create( 0, opd.Elmt[1], opd.Elmt[2], opd.Elmt[3], fvalue[0], fvalue[1], fvalue[2], 0 )
    else
      if opd is tga3dbv then
        result := tga3dbv.Create( fvalue[0] + opd.Elmt[4], fvalue[1] + opd.Elmt[5], fvalue[2] + opd.Elmt[6] )
      else
        if opd is tga3dtv then
          result := tga3dmv.Create( 0, 0, 0, 0, fvalue[0], fvalue[1], fvalue[2], opd.Elmt[7] )
        else
          result := tga3dmv.Create( opd.Elmt[0], opd.Elmt[1], opd.Elmt[2], opd.Elmt[3], fvalue[0] + opd.Elmt[4], fvalue[1] + opd.Elmt[5], fvalue[2] + opd.Elmt[6], opd.Elmt[7] );
end;

constructor TGA3Dbv.Create( e12, e23, e31: real );
begin
  fvalue[0] := e12;
  fvalue[1] := e23;
  fvalue[2] := e31;
end;

function TGA3Dbv.GetElmt( idx: integer ): real;
begin
  if idx in [4..6] then
    result := fvalue[idx - 4]
  else
    result := 0;
end;

function TGA3Dbv.mag: real;
begin
  result := sqrt( fvalue[0] * fvalue[0] + fvalue[1] * fvalue[1] + fvalue[2] * fvalue[2] );
end;

function TGA3Dbv.mul( opd: TGA3DObject ): TGA3DObject;
begin
  if opd is tga3ds then
    result := tga3dbv.Create( fvalue[0] * opd.Elmt[0], fvalue[1] * opd.Elmt[0], fvalue[2] * opd.Elmt[0] )
  else
    if opd is tga3dv then
      result := tga3dmv.Create( 0,
        fvalue[0] * opd.Elmt[2] - fvalue[2] * opd.Elmt[3],
        fvalue[1] * opd.Elmt[3] - fvalue[0] * opd.Elmt[1],
        fvalue[2] * opd.Elmt[1] - fvalue[1] * opd.Elmt[2],
        0, 0, 0,
        fvalue[0] * opd.Elmt[3] + fvalue[1] * opd.Elmt[1] + fvalue[2] * opd.Elmt[2]
        )
    else
      if opd is tga3dbv then
        result := tga3dmv.Create(
          -fvalue[0] * opd.Elmt[4] - fvalue[1] * opd.Elmt[5] - fvalue[2] * opd.Elmt[6],
          0, 0, 0,
          fvalue[2] * opd.Elmt[5] - fvalue[1] * opd.Elmt[6],
          fvalue[0] * opd.Elmt[6] - fvalue[2] * opd.Elmt[4],
          fvalue[1] * opd.Elmt[4] - fvalue[0] * opd.Elmt[5],
          0
          )
      else
        if opd is tga3dtv then
          result := tga3dv.Create( -fvalue[1] * opd.Elmt[7], -fvalue[2] * opd.Elmt[7], -fvalue[0] * opd.Elmt[7] )
        else
          result := tga3dmv.Create(
            -fvalue[0] * opd.Elmt[4] - fvalue[1] * opd.Elmt[5] - fvalue[2] * opd.Elmt[6],

            fvalue[0] * opd.Elmt[2] - fvalue[2] * opd.Elmt[3] - fvalue[1] * opd.Elmt[7],
            fvalue[1] * opd.Elmt[3] - fvalue[0] * opd.Elmt[1] - fvalue[2] * opd.Elmt[7],
            fvalue[2] * opd.Elmt[1] - fvalue[1] * opd.Elmt[2] - fvalue[0] * opd.Elmt[7],

            fvalue[2] * opd.Elmt[5] - fvalue[1] * opd.Elmt[6] + fvalue[0] * opd.Elmt[0],
            fvalue[0] * opd.Elmt[6] - fvalue[2] * opd.Elmt[4] + fvalue[1] * opd.Elmt[0],
            fvalue[1] * opd.Elmt[4] - fvalue[0] * opd.Elmt[5] + fvalue[2] * opd.Elmt[0],

            fvalue[0] * opd.Elmt[3] + fvalue[1] * opd.Elmt[1] + fvalue[2] * opd.Elmt[2]
            );
end;

procedure TGA3Dbv.neg;
begin
  inherited;
  fvalue[0] := -fvalue[0];
  fvalue[1] := -fvalue[1];
  fvalue[2] := -fvalue[2];
end;

procedure TGA3Dbv.nor;
var
  len, inv          : real;
begin
  inherited;
  len := mag;
  if len > 1E-3 then begin
    inv := 1.0 / len;
    fvalue[0] := fvalue[0] * inv;
    fvalue[1] := fvalue[1] * inv;
    fvalue[2] := fvalue[2] * inv;
  end;
end;

procedure TGA3Dbv.rev;
begin
  inherited;
  fvalue[0] := -fvalue[0];
  fvalue[1] := -fvalue[1];
  fvalue[2] := -fvalue[2];
end;

function TGA3Dbv.sub( opd: TGA3DObject ): TGA3DObject;
begin
  if opd is tga3ds then
    result := tga3dmv.Create( -opd.Elmt[0], 0, 0, 0, fvalue[0], fvalue[1], fvalue[2], 0 )
  else
    if opd is tga3dv then
      result := tga3dmv.Create( 0, -opd.Elmt[1], -opd.Elmt[2], -opd.Elmt[3], fvalue[0], fvalue[1], fvalue[2], 0 )
    else
      if opd is tga3dbv then
        result := tga3dbv.Create( fvalue[0] - opd.Elmt[4], fvalue[1] - opd.Elmt[5], fvalue[2] - opd.Elmt[6] )
      else
        if opd is tga3dtv then
          result := tga3dmv.Create( 0, 0, 0, 0, fvalue[0], fvalue[1], fvalue[2], -opd.Elmt[7] )
        else
          result := tga3dmv.Create( -opd.Elmt[0], -opd.Elmt[1], -opd.Elmt[2], -opd.Elmt[3], fvalue[0] - opd.Elmt[4], fvalue[1] - opd.Elmt[5], fvalue[2] - opd.Elmt[6], -opd.Elmt[7] );
end;

{ TGA3Dtv }

function TGA3Dtv.add( opd: TGA3DObject ): TGA3DObject;
begin
  if opd is tga3ds then
    result := tga3dmv.Create( opd.Elmt[0], 0, 0, 0, 0, 0, 0, fvalue )
  else
    if opd is tga3dv then
      result := tga3dmv.Create( 0,
        opd.Elmt[1], opd.Elmt[2], opd.Elmt[3],
        0, 0, 0,
        fvalue )
    else
      if opd is tga3dbv then
        result := tga3dmv.Create( 0,
          0, 0, 0,
          opd.Elmt[4], opd.Elmt[5], opd.Elmt[6],
          fvalue )
      else
        if opd is tga3dtv then
          result := tga3dtv.Create( fvalue + opd.Elmt[7] )
        else
          result := tga3dmv.Create( opd.Elmt[0],
            opd.Elmt[1], opd.Elmt[2], opd.Elmt[3],
            opd.Elmt[4], opd.Elmt[5], opd.Elmt[6],
            fvalue + opd.Elmt[7] );
end;

constructor TGA3Dtv.Create( e123: real );
begin
  fvalue := e123;
end;

function TGA3Dtv.GetElmt( idx: integer ): real;
begin
  if idx = 7 then
    result := fvalue
  else
    result := 0;
end;

function TGA3Dtv.mag: real;
begin
  result := abs( fvalue );
end;

function TGA3Dtv.mul( opd: TGA3DObject ): TGA3DObject;
begin
  if opd is tga3ds then
    result := tga3dtv.Create( fvalue * opd.Elmt[0] )
  else
    if opd is tga3dv then
      result := tga3dbv.Create( fvalue * opd.Elmt[3], fvalue * opd.Elmt[1], fvalue * opd.Elmt[2] )
    else
      if opd is tga3dbv then
        result := tga3dv.Create( -fvalue * opd.Elmt[5], -fvalue * opd.Elmt[6], -fvalue * opd.Elmt[4] )
      else
        if opd is tga3dtv then
          result := tga3ds.Create( -fvalue * opd.Elmt[7] )
        else
          result := tga3dmv.Create(
            -fvalue * opd.Elmt[7],
            -fvalue * opd.Elmt[5], -fvalue * opd.Elmt[6], -fvalue * opd.Elmt[4],
            fvalue * opd.Elmt[3], fvalue * opd.Elmt[1], fvalue * opd.Elmt[2],
            fvalue * opd.Elmt[0]
            );
end;

procedure TGA3Dtv.neg;
begin
  inherited;
  fvalue := -fvalue;
end;

procedure TGA3Dtv.nor;
begin
  inherited;
  fvalue := 1;
end;

procedure TGA3Dtv.rev;
begin
  inherited;
  fvalue := -fvalue;
end;

function TGA3Dtv.sub( opd: TGA3DObject ): TGA3DObject;
begin
  if opd is tga3ds then
    result := tga3dmv.Create( -opd.Elmt[0], 0, 0, 0, 0, 0, 0, fvalue )
  else
    if opd is tga3dv then
      result := tga3dmv.Create( 0,
        -opd.Elmt[1], -opd.Elmt[2], -opd.Elmt[3],
        0, 0, 0,
        fvalue )
    else
      if opd is tga3dbv then
        result := tga3dmv.Create( 0,
          0, 0, 0,
          -opd.Elmt[4], -opd.Elmt[5], -opd.Elmt[6],
          fvalue )
      else
        if opd is tga3dtv then
          result := tga3dtv.Create( fvalue - opd.Elmt[7] )
        else
          result := tga3dmv.Create( -opd.Elmt[0],
            -opd.Elmt[1], -opd.Elmt[2], -opd.Elmt[3],
            -opd.Elmt[4], -opd.Elmt[5], -opd.Elmt[6],
            fvalue - opd.Elmt[7] );
end;

{ TGA3Dmv }

function TGA3Dmv.add( opd: TGA3DObject ): TGA3DObject;
begin
  result := tga3dmv.Create(
    fvalue[0] + opd.Elmt[0],

    fvalue[1] + opd.Elmt[1],
    fvalue[2] + opd.Elmt[2],
    fvalue[3] + opd.Elmt[3],

    fvalue[4] + opd.Elmt[4],
    fvalue[5] + opd.Elmt[5],
    fvalue[6] + opd.Elmt[6],

    fvalue[7] + opd.Elmt[7]
    );
end;

constructor TGA3Dmv.Create( s, e1, e2, e3, e12, e23, e31, e123: real );
begin
  fvalue[0] := s;
  fvalue[1] := e1;
  fvalue[2] := e2;
  fvalue[3] := e3;
  fvalue[4] := e12;
  fvalue[5] := e23;
  fvalue[6] := e31;
  fvalue[7] := e123;
end;

function TGA3Dmv.GetElmt( idx: integer ): real;
begin
  result := fvalue[idx];
end;

function TGA3Dmv.mag: real;
begin
  result := sqrt( fvalue[0] * fvalue[0]
    + fvalue[1] * fvalue[1] + fvalue[2] * fvalue[2] + fvalue[3] * fvalue[3]
    + fvalue[4] * fvalue[4] + fvalue[5] * fvalue[5] + fvalue[6] * fvalue[6]
    + fvalue[7] * fvalue[7] );
end;

function TGA3Dmv.mul( opd: TGA3DObject ): TGA3DObject;
begin
  result := tga3dmv.Create(
    fvalue[0] * opd.Elmt[0]
    + fvalue[1] * opd.Elmt[1] + fvalue[2] * opd.Elmt[2] + fvalue[3] * opd.Elmt[3]
    + fvalue[4] * opd.Elmt[4] + fvalue[5] * opd.Elmt[5] + fvalue[6] * opd.Elmt[6]
    + fvalue[7] * opd.Elmt[7],

    //vector part
    fvalue[0] * opd.Elmt[1]
    + fvalue[1] * opd.Elmt[0] - fvalue[2] * opd.Elmt[4] + fvalue[3] * opd.Elmt[6]
    + fvalue[4] * opd.Elmt[2] + fvalue[5] * opd.Elmt[7] - fvalue[6] * opd.Elmt[3]
    - fvalue[7] * opd.Elmt[5],

    fvalue[0] * opd.Elmt[2]
    + fvalue[1] * opd.Elmt[4] + fvalue[2] * opd.Elmt[0] - fvalue[3] * opd.Elmt[5]
    - fvalue[4] * opd.Elmt[1] + fvalue[5] * opd.Elmt[3] - fvalue[6] * opd.Elmt[7]
    - fvalue[7] * opd.Elmt[6],

    fvalue[0] * opd.Elmt[3]
    - fvalue[1] * opd.Elmt[6] + fvalue[2] * opd.Elmt[5] + fvalue[3] * opd.Elmt[0]
    - fvalue[4] * opd.Elmt[7] - fvalue[5] * opd.Elmt[2] + fvalue[6] * opd.Elmt[1]
    - fvalue[7] * opd.Elmt[4],

    //bivector part
    fvalue[0] * opd.Elmt[4]
    + fvalue[1] * opd.Elmt[2] - fvalue[2] * opd.Elmt[1] + fvalue[3] * opd.Elmt[7]
    + fvalue[4] * opd.Elmt[0] - fvalue[5] * opd.Elmt[6] + fvalue[6] * opd.Elmt[5]
    + fvalue[7] * opd.Elmt[3],

    fvalue[0] * opd.Elmt[5]
    + fvalue[1] * opd.Elmt[7] + fvalue[2] * opd.Elmt[3] - fvalue[3] * opd.Elmt[2]
    + fvalue[4] * opd.Elmt[6] + fvalue[5] * opd.Elmt[0] - fvalue[6] * opd.Elmt[4]
    + fvalue[7] * opd.Elmt[1],

    fvalue[0] * opd.Elmt[6]
    - fvalue[1] * opd.Elmt[3] + fvalue[2] * opd.Elmt[7] + fvalue[3] * opd.Elmt[1]
    - fvalue[4] * opd.Elmt[5] + fvalue[5] * opd.Elmt[4] + fvalue[6] * opd.Elmt[0]
    + fvalue[7] * opd.Elmt[2],

    //pseudoscalar
    fvalue[0] * opd.Elmt[7]
    + fvalue[1] * opd.Elmt[5] + fvalue[2] * opd.Elmt[6] + fvalue[3] * opd.Elmt[4]
    + fvalue[4] * opd.Elmt[3] + fvalue[5] * opd.Elmt[1] + fvalue[6] * opd.Elmt[2]
    + fvalue[7] * opd.Elmt[0]
    );
end;

procedure TGA3Dmv.neg;
begin
  inherited;
  fvalue[0] := -fvalue[0];
  fvalue[1] := -fvalue[1];
  fvalue[2] := -fvalue[2];
  fvalue[3] := -fvalue[3];
  fvalue[4] := -fvalue[4];
  fvalue[5] := -fvalue[5];
  fvalue[6] := -fvalue[6];
  fvalue[7] := -fvalue[7];
end;

procedure TGA3Dmv.nor;
var
  len, inv          : real;
begin
  inherited;
  len := mag;
  if len > 1E-3 then begin
    inv := 1.0 / len;
    fvalue[0] := fvalue[0] * inv;
    fvalue[1] := fvalue[1] * inv;
    fvalue[2] := fvalue[2] * inv;
    fvalue[3] := fvalue[3] * inv;
    fvalue[4] := fvalue[4] * inv;
    fvalue[5] := fvalue[5] * inv;
    fvalue[6] := fvalue[6] * inv;
    fvalue[7] := fvalue[7] * inv;
  end;
end;

procedure TGA3Dmv.rev;
begin
  inherited;
  fvalue[4] := -fvalue[4];
  fvalue[5] := -fvalue[5];
  fvalue[6] := -fvalue[6];
  fvalue[7] := -fvalue[7];
end;

function TGA3Dmv.sub( opd: TGA3DObject ): TGA3DObject;
begin
  result := tga3dmv.Create(
    fvalue[0] - opd.Elmt[0],

    fvalue[1] - opd.Elmt[1],
    fvalue[2] - opd.Elmt[2],
    fvalue[3] - opd.Elmt[3],

    fvalue[4] - opd.Elmt[4],
    fvalue[5] - opd.Elmt[5],
    fvalue[6] - opd.Elmt[6],

    fvalue[7] - opd.Elmt[7]
    );
end;

initialization
  ga3dI := tga3dtv.Create( 1 );
finalization
  ga3dI.Free;
end.

