{

    Se cuenta con un archivo de productos de una cadena de venta de alimentos congelados.
    De cada producto se almacena: código del producto, nombre, descripción, stock disponible,
    stock mínimo y precio del producto.

    Se recibe diariamente un archivo detalle de cada una de las 30 sucursales de la cadena. Se
    debe realizar el procedimiento que recibe los 30 detalles y actualiza el stock del archivo
    maestro. La información que se recibe en los detalles es: código de producto y cantidad
    vendida. Además, se deberá informar en un archivo de texto: nombre de producto,
    descripción, stock disponible y precio de aquellos productos que tengan stock disponible por
    debajo del stock mínimo.

    Nota: todos los archivos se encuentran ordenados por código de productos. En cada detalle
    puede venir 0 o N registros de un determinado producto.

}

program ejercicio3;

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
        cant: integer;
    end;

    archivo_maestro = file of producto;
    archivo_detalle = file of producto_detalle;
    
    arreglo_archivo_detalles = array [1..cant_detalles] of archivo_detalle;
    arreglo_detalles = array[1..cant_detalles] of producto_detalle;
    
    /////////////////////////////////////////////////
        //Leyendo registros.
    /////////////////////////////////////////////////

    procedure leer_producto(var reg_m: producto);
    begin
        write('Ingrese codigo de producto: ');
        readln(reg_m.cod);
        if(reg_m.cod <> valor_corte) then begin
            write('Ingrese nombre de producto: ');
            readln(reg_m.nombre);
            write('Ingrese descripción de producto: ');
            readln(reg_m.descripcion);
            write('Ingrese stock disponible de producto: ');
            readln(reg_m.stock_disponible);
            write('Ingrese stock minimo de producto: ');
            readln(reg_m.stock_minimo);
            write('Ingrese precio de producto: ');
            readln(reg_m.precio);
        end;
    end;

    procedure leer_producto_detalle(var reg_d: producto_detalle);
    begin
        write('Ingrese codigo de producto: ');
        readln(reg_d.cod);
        if(reg_d.cod <> valor_corte) then begin
            write('Ingrese cantidad vendida de producto: ');
            readln(reg_d.cant);
        end;
    end;

    procedure imprimir_producto(var reg_m: producto);
    begin
        write('Codigo: ', reg_m.cod, #10, 'Nombre: ', reg_m.nombre, #10, 'Descripcion: ', reg_m.descripcion, #10, 'Stock disponible: ', reg_m.stock_disponible, #10, 'Stock minimo: ', reg_m.stock_minimo, #10,'Precio: ', reg_m.precio,#10);
    end;

    
    /////////////////////////////////////////////////
        // Creacion de archivos
    /////////////////////////////////////////////////

    procedure crear_archivo_maestro(var archivo: archivo_maestro);
    var
        reg_m: producto;
    begin
        rewrite(archivo);
        leer_producto(reg_m);
        while(reg_m.cod <> valor_corte) do begin
            write(archivo,reg_m);
            leer_producto(reg_m);
        end;
        close(archivo);
    end;

    procedure crear_archivo_detalle(var archivo: arreglo_archivo_detalles);
    var
        i_str: string[30];
        i:integer;
        reg_d: producto_detalle;
    begin
        for i:= 1 to cant_detalles do begin

            Str(i,i_str);
            Assign(archivo[i],'Detalle ' + i_str);
            rewrite(archivo[i]);

            leer_producto_detalle(reg_d);
            while(reg_d.cod <> valor_corte) do begin
                write(archivo[i],reg_d);
                leer_producto_detalle(reg_d);
            end;

            close(archivo[i]);
        end;
    end;

    /////////////////////////////////////////////////
        // Actualizacion de archivos
    /////////////////////////////////////////////////

    procedure leer(var archivoD: archivo_detalle; var reg_d: producto_detalle);
    begin
        if not eof(archivoD) then 
            read(archivoD,reg_d)
        else
            reg_d.cod := valor_corte;
    end;

    procedure minimo(var arreglo_registro: arreglo_detalles; var arreglo_archivoD:arreglo_archivo_detalles; var min: producto_detalle);
    var
        minCod,i,pos:integer;
        minimo: producto_detalle;
    begin
        minCod := 9999;
        pos:= 1;
        for i:= 1 to cant_detalles do begin
            if(arreglo_registro[i].cod < minCod) then begin
                minCod:= arreglo_registro[i].cod;
                pos:= i;
                min:= arreglo_registro[i];
            end;
        end;
        leer(arreglo_archivoD[pos],arreglo_registro[pos]);
    end;

    procedure actualizar_maestro(var arreglo_archivoD:arreglo_archivo_detalles; var archivoM: archivo_maestro);
    var

        i:integer;
        vector_regD: arreglo_detalles;
        reg_m: producto;
        reg_d: producto_detalle;
        cod_act,total_vendido: integer;
        archivo_text: Text;

    begin

        for i:= 1 to cant_detalles do begin
            reset(arreglo_archivoD[i]);
            leer(arreglo_archivoD[i],vector_regD[i]);
        end;

        Assign(archivo_text,'productos.txt');
        rewrite(archivo_text);
        reset(archivoM);
        minimo(vector_regD,arreglo_archivoD,reg_d);
        while(reg_d.cod <> valor_corte) do begin
            read(archivoM,reg_m);

            while (reg_d.cod <> reg_m.cod) do begin
                read(archivoM,reg_m);
            end;

            while(reg_d.cod = reg_m.cod) do begin
                
                reg_m.stock_disponible := reg_m.stock_disponible - reg_d.cant;
                if(reg_m.stock_disponible < reg_m.stock_minimo) then
                    write(archivo_text,'Codigo: ', reg_m.cod, #10, 'Nombre: ', reg_m.nombre, #10, 'Descripcion: ', reg_m.descripcion, #10, 'Stock disponible: ', reg_m.stock_disponible, #10, 'Stock minimo: ', reg_m.stock_minimo, #10,'Precio: ', reg_m.precio,#10);
                minimo(vector_regD,arreglo_archivoD,reg_d);
            end;

            seek(archivoM,filepos(archivoM)-1);
            write(archivoM,reg_m);
        end;

        for i:= 1 to cant_detalles do begin
            close(arreglo_archivoD[i]);
        end;
        close(archivoM);
        close(archivo_text);
    end;


var
    archivo_m: archivo_maestro;
    archivo_d: arreglo_archivo_detalles;
    
begin
    Assign(archivo_m, 'maestro');
    crear_archivo_maestro(archivo_m);
    crear_archivo_detalle(archivo_d);
    actualizar_maestro(archivo_d,archivo_m);
end.