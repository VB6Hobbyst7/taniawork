<?php
   $mysql = mysql_connect('31.222.177.156', 'root', 'radr');
    mysql_select_db( 'dyntoc' );
    $Query = "select * from curatortags where bookname = '".$_POST['s1']."'";
    $Result = mysql_query( $Query );
    $Return = "<tags>";
   while ( $row = mysql_fetch_array( $Result ) )
   {
     $Return .= "<tag>
     <id>".$row[id]."</id>
     <bookname>".$row[bookname]."</bookname>
     <xmlid>".$row[xmlid]."</xmlid>
     <xmlname>".$row[xmlname]."</xmlname>
     <curatorname>".$row[curatorname]."</curatorname>
     <visible>".$row[visible]."</visible>
      <tcount>".$row[tcount]."</tcount>
     </tag>"; 
     echo ("\r\n");
   }
   $Return .= "</tags>";
   mysql_free_result( $Result );
   print ($Return);
 ?>