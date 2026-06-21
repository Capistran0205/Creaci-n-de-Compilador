/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package Compilador.app.com;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

/**
 * Generador de los analizadores del compilador.
 *
 * Corre JFlex (lexers) y CUP (parser). Como CUP escribe sym.java y
 * Sintactico.java en el directorio de trabajo (la raiz del proyecto al
 * ejecutar desde NetBeans), aqui se reubican en su carpeta de paquete.
 *
 * FLUJO:  corre Main -> reconstruye el proyecto -> prueba desde la interfaz.
 */
public class Main {

    // ===========================================================
    //  >>>>>  EDITA ESTA LINEA con la raiz de TU proyecto  <<<<<
    // ===========================================================
    static final String BASE =
        "C:/Users/capis/OneDrive/Documentos/NetBeansProjects/Compilador";

    // ---- Carpetas (paquetes) de cada analizador ----
    static final String DIR_LEXICO = BASE + "/src/AnalizadorLexico/app/com";
    static final String DIR_SINTACTICO = BASE + "/src/AnalizadorSintactico/app/com";

    // Nombre del paquete del sintactico (lo necesita CUP con -package)
    static final String PKG_SINTACTICO = "AnalizadorSintactico.app.com";

    public static void main(String[] args) throws Exception {
        // 1) Lexer que llena la tabla de tokens (devuelve el enum Token)
        generarLexer(DIR_LEXICO + "/Lexico.flex");

        // 2) Lexer del parser + parser CUP (con package, para que al
        //    moverlos a su carpeta compilen sin broncas)
        generarLexerYParser(
            DIR_SINTACTICO + "/LexerCup.flex",
            new String[]{
                "-parser",  "Sintactico",
                "-package", PKG_SINTACTICO,
                DIR_SINTACTICO + "/Sintactico.cup"
            }
        );

        System.out.println(">> Listo: lexers y parser generados y reubicados.");
    }

    /** Genera un lexer JFlex; queda junto a su .flex (no se mueve). */
    public static void generarLexer(String rutaFlex) {
        JFlex.Main.generate(new File(rutaFlex));
    }

    /** Genera el lexer del parser y, con CUP, sym.java + Sintactico.java,
     *  y los reubica en la carpeta del paquete sintactico. */
    public static void generarLexerYParser(String rutaFlexCup, String[] argsCup)
            throws Exception {
        // Lexer que alimenta al parser (queda junto al .flex)
        JFlex.Main.generate(new File(rutaFlexCup));

        // Parser CUP: escribe sym.java y Sintactico.java en el dir de trabajo
        java_cup.Main.main(argsCup);

        // CUP los deja en la carpeta desde donde corres (raiz del proyecto).
        String dirTrabajo = System.getProperty("user.dir");
        mover(dirTrabajo + "/sym.java",        DIR_SINTACTICO + "/sym.java");
        mover(dirTrabajo + "/Sintactico.java", DIR_SINTACTICO + "/Sintactico.java");
    }

    /** Mueve un archivo generado a su carpeta de paquete, reemplazando el anterior. */
    private static void mover(String origen, String destino) throws IOException {
        Path dst = Paths.get(destino);
        Files.deleteIfExists(dst);          // borra la version vieja si existe
        Files.move(Paths.get(origen), dst); // coloca la nueva
    }
}