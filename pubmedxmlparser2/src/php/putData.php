<?php
   mysql_connect('localhost', 'root', '');
   mysql_select_db( 'scpubmed3' );
   $text = strip_punctuation( $_POST['s3'] );
   $text = strip_symbols( $text );
   $Query = str_replace('\\','',"INSERT INTO list VALUES ('', '".$_POST['s1']."', '".$_POST['s2']."', '".$text."', '".$_POST['s4']."', '".$_POST['s5']."', '".$_POST['s6']."', '".$_POST['s7']."')");
   $Result = mysql_query( $Query ) or die('Query failed: ' . mysql_error());
   print("done");



function strip_punctuation( $text5 )
{
    $urlbrackets    = '\[\]\(\)';
    $urlspacebefore = ':;\'_\*%@&?!' . $urlbrackets;
    $urlspaceafter  = '\.,:;\'\-_\*@&\/\\\\\?!#' . $urlbrackets;
    $urlall         = '\.,:;\'\-_\*%@&\/\\\\\?!#' . $urlbrackets;
 
    $specialquotes  = '\'"\*<>';
 
    $fullstop       = '\x{002E}\x{FE52}\x{FF0E}';
    $comma          = '\x{002C}\x{FE50}\x{FF0C}';
    $arabsep        = '\x{066B}\x{066C}';
    $numseparators  = $fullstop . $comma . $arabsep;
 
    $numbersign     = '\x{0023}\x{FE5F}\x{FF03}';
    $percent        = '\x{066A}\x{0025}\x{066A}\x{FE6A}\x{FF05}\x{2030}\x{2031}';
    $prime          = '\x{2032}\x{2033}\x{2034}\x{2057}';
    $nummodifiers   = $numbersign . $percent . $prime;
 
    return preg_replace(
        array(
        // Remove separator, control, formatting, surrogate,
        // open/close quotes.
            '/[\p{Z}\p{Cc}\p{Cf}\p{Cs}\p{Pi}\p{Pf}]/u',
        // Remove other punctuation except special cases
            '/\p{Po}(?<![' . $specialquotes .
                $numseparators . $urlall . $nummodifiers . '])/u',
        // Remove non-URL open/close brackets, except URL brackets.
            '/[\p{Ps}\p{Pe}](?<![' . $urlbrackets . '])/u',
        // Remove special quotes, dashes, connectors, number
        // separators, and URL characters followed by a space
            '/[' . $specialquotes . $numseparators . $urlspaceafter .
                '\p{Pd}\p{Pc}]+((?= )|$)/u',
        // Remove special quotes, connectors, and URL characters
        // preceded by a space
            '/((?<= )|^)[' . $specialquotes . $urlspacebefore . '\p{Pc}]+/u',
        // Remove dashes preceded by a space, but not followed by a number
            '/((?<= )|^)\p{Pd}+(?![\p{N}\p{Sc}])/u',
        // Remove consecutive spaces
            '/ +/',
        ),
        ' ',
        $text5 );
}

function strip_symbols( $text4 )
{
    $plus   = '\+\x{FE62}\x{FF0B}\x{208A}\x{207A}';
    $minus  = '\x{2012}\x{208B}\x{207B}';
 
    $units  = '\\x{00B0}\x{2103}\x{2109}\\x{23CD}';
    $units .= '\\x{32CC}-\\x{32CE}';
    $units .= '\\x{3300}-\\x{3357}';
    $units .= '\\x{3371}-\\x{33DF}';
    $units .= '\\x{33FF}';
 
    $ideo   = '\\x{2E80}-\\x{2EF3}';
    $ideo  .= '\\x{2F00}-\\x{2FD5}';
    $ideo  .= '\\x{2FF0}-\\x{2FFB}';
    $ideo  .= '\\x{3037}-\\x{303F}';
    $ideo  .= '\\x{3190}-\\x{319F}';
    $ideo  .= '\\x{31C0}-\\x{31CF}';
    $ideo  .= '\\x{32C0}-\\x{32CB}';
    $ideo  .= '\\x{3358}-\\x{3370}';
    $ideo  .= '\\x{33E0}-\\x{33FE}';
    $ideo  .= '\\x{A490}-\\x{A4C6}';
 
    return preg_replace(
        array(
        // Remove modifier and private use symbols.
            '/[\p{Sk}\p{Co}]/u',
        // Remove mathematics symbols except + - = ~ and fraction slash
            '/\p{Sm}(?<![' . $plus . $minus . '=~\x{2044}])/u',
        // Remove + - if space before, no number or currency after
            '/((?<= )|^)[' . $plus . $minus . ']+((?![\p{N}\p{Sc}])|$)/u',
        // Remove = if space before
            '/((?<= )|^)=+/u',
        // Remove + - = ~ if space after
            '/[' . $plus . $minus . '=~]+((?= )|$)/u',
        // Remove other symbols except units and ideograph parts
            '/\p{So}(?<![' . $units . $ideo . '])/u',
        // Remove consecutive white space
            '/ +/',
        ),
        ' ',
        $text4 );
}
 ?>