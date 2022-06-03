program parcial;
const
    valor_corte = 9999;
    cant_detalles = 30;
type

    producto = record
        cod: integer;
        nombre: string[25];
        descripcion: string[25];
        stock_disponible: integer;
        stock_minimo: integer;
        precio: real;
    end;

    producto_detalle = record
        cod: integer;
        cant_vendida: integer;
    end;

    archivo_maestro = file of producto;
    archivo_detalle = file of producto_detalle;

    arreglo_archivo_detalle = array [1..cant_detalles] of archivo_detalle;
    arreglo_registro_detalle = array [1..cant_detalles] of producto_detalle;



    procedure leer(var archivoD: archivo_detalle; var regD: producto_detalle);
    begin
        if not eof(archivoD) then
            read(archivoD,regD)
        else
            regD.cod := valor_corte;
    end;

    procedure minimo(var arreglo_reg: arreglo_registro_detalle; var arreglo_archD:arreglo_archivo_detalle; var min: producto_detalle);
    var
        minPos,i: integer;
    begin
        minPos:= 1;
        min.cod:= valor_corte;
        for i:= 1 to cant_detalles do begin
            if(arreglo_reg[i].cod < min.cod) then begin
                minPos:= i;
                min:= arreglo_reg[i];
            end;
        end;

        if(min.cod <> valor_corte) then
            leer(arreglo_archD[minPos],arreglo_reg[minPos]);
    end;

    procedure actualizar_maestro(var archivoM: archivo_maestro; var archivoD: arreglo_archivo_detalle; var archivoTxt: Text);
    var
        arreglo_regD: arreglo_registro_detalle;
        reg_M: producto;
        reg_D: producto_detalle;
        i:integer;
    begin

        for i:= 1 to cant_detalles do begin
            reset(archivoD[i]);
            leer(archivoD[i],arreglo_regD[i]);
        end;

        rewrite(archivoTxt);
        reset(archivoM);
        minimo(arreglo_regD,archivoD,reg_d);

        while(reg_d.cod <> valor_corte) do begin

            read(archivoM,reg_M);
            while(reg_d.cod <> reg_M.cod) do begin
                read(archivoM,reg_M);
            end;

            while(reg_d.cod = reg_M.cod) do begin
                reg_M.stock_disponible :=  reg_M.stock_disponible - reg_d.cant_vendida;
                minimo(arreglo_regD,archivoD,reg_d);
            end;

            seek(archivoM,filepos(archivoM) - 1);
            write(archivoM,reg_M);
            if(reg_M.stock_disponible < reg_M.stock_minimo) then
                write(archivoTxt,'Nombre: ', reg_M.nombre, #10, 'Descripcion: ', reg_M.descripcion, #10, 'stock_disponible: ', reg_M.stock_disponible, #10, 'Precio: ', reg_M.precio, #10);
        end;
        

        for i:= 1 to cant_detalles do begin
            close(archivoD[i]);
        end;
        close(archivoM);
        close(archivoTxt);
    end;


var
    archivoM: archivo_maestro;
    archivoD: arreglo_archivo_detalle;
    archivo_text: Text;
begin
    Assign(archivo_text,'informar.txt');
    Assign(archivoM,'maestro');
    crear_archivo_detalle(archivoD); // se dispone
    actualizar_maestro(archivoM,archivoD,archivo_text);
end.