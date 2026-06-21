# Contexto del proyecto: Compilador de **Infinix**

Compilador **didáctico** (proyecto NetBeans / Java + Swing) para un lenguaje propio
llamado **Infinix**. Implementa las **dos primeras fases** de un compilador: análisis
**léxico** y análisis **sintáctico**, con visualización del **Árbol de Análisis
Sintáctico (AAS)**. Aún no incluye fase semántica ni generación de código.

## Arquitectura por paquetes

| Paquete (carpeta) | Rol |
|---|---|
| `src/AnalizadorLexico/app/com/` | Léxico para la interfaz: `Lexico.flex` → `AnalizadorLexico.java`. Devuelve el enum `Token` y expone el lexema en el campo público `lexeme`. Apoyado por `Token` y `Categoria`. |
| `src/AnalizadorSintactico/app/com/` | Sintáctico CUP: `LexerCup.flex` (modo `%cup`, emite `Symbol`) + `Sintactico.cup` → `Sintactico.java` y `sym.java`. |
| `src/AAS/app/com/` | Árbol sintáctico: `Nodo` (estructura recursiva), `ArbolJGrapht` (lo pasa a un grafo dirigido de **JGraphT**) y `VisualizadorArbol` (lo dibuja con **JGraphX/mxGraph** en layout jerárquico). |
| `src/Compilador/app/com/` | `InterfazCompilador` (JFrame principal), `Main` (generador de analizadores) y las `Librerias/` (JFlex, java-cup, jgrapht, jgraphx). |
| `src/CodigosFuenteInfinix/app/com/` | Ejemplos: `CodigoLimpio.txt` (válido) y `CodigoErroneo.txt` (con errores para probar el modo pánico). |

## El lenguaje Infinix

- **Tipos de dato:** `entero`, `decimal`, `caracter`, `cadena`, `booleano`
- **Booleanos:** `verdadero`, `falso` (clasificados como LITERAL)
- **E/S:** `mt < ... >` (salida / print) e `inp < id >` (entrada)
- **Operadores:** `+ - * /`; **símbolos:** `=`, `,`, `<`, `>`, `(`, `)`, `'`
- **Fin de instrucción:** el token `:_:` (cada sentencia termina así)
- **Literales:** número `digitos(.digitos)?`, cadena delimitada por `@...@`, carácter `'c'`
- **Comentarios:** de una línea con `#` (estilo Python) y multilínea `/* */`
- **Gramática (CUP):** `programa → instruccion*`; instrucciones de **declaración**
  (con lista separada por comas e inicialización opcional), **asignación**, **salida**
  y **entrada**; expresiones con precedencia `expresion → termino → factor`
  (suma/resta sobre mult/div, paréntesis).

### Ejemplo válido (`CodigoLimpio.txt`)

```
entero contador = 0, limite = 10 :_:
decimal promedio = 85.5 :_:
cadena mensaje = @Resultado final@ :_:
caracter grado = 'B' :_:
booleano aprobado = true :_:
contador = (limite - 2) * 3 + 1 / 2 :_:
mt < mensaje, promedio, grado > :_:
inp < contador > :_:
```

## Flujo de trabajo

1. Se ejecuta `Main.java`: corre **JFlex** sobre los `.flex` y **CUP** sobre el `.cup`,
   y **reubica** `sym.java` / `Sintactico.java` en su paquete (porque CUP los escribe
   en la raíz del proyecto). La constante `BASE` apunta a la ruta local del proyecto.
2. Se reconstruye el proyecto en NetBeans.
3. En `InterfazCompilador` el usuario carga/edita código y pulsa:
   - **Analizador Léxico** → vuelca los tokens a una tabla (Token / Lexema / Patrón),
     marcando errores con su línea.
   - **Analizador Sintáctico** → corre el parser; si hay errores los lista numerados con
     sugerencias; si es correcto, **abre la ventana del árbol** (AAS).

## Características destacadas

- **Manejo de errores sintácticos elaborado** (`Sintactico.cup`): recuperación en modo
  pánico (`error FIN_LINEA`), recolección de **todos** los errores y un sistema de
  **sugerencias contextuales** (falta coma, falta `:_:`, identificador inválido,
  paréntesis sin cerrar…) que usa reflexión sobre `sym` para saber qué terminales se
  esperaban en cada estado.
- **Resaltado de sintaxis** en vivo en el editor (regex por categorías, evitando
  colorear contenido dentro de cadenas / caracteres).
- **Visualización del AAS** con JGraphT + JGraphX en layout jerárquico interactivo
  (zoom y desplazamiento).

## Stack tecnológico

- **Java + Swing** (NetBeans, AbsoluteLayout).
- **JFlex 1.4.3** — generación de analizadores léxicos.
- **CUP 0.11b** — generación del analizador sintáctico LALR.
- **JGraphT 1.5.2** — modelo de grafo del árbol sintáctico.
- **JGraphX (mxGraph) 4.2.2** — render visual del árbol.
