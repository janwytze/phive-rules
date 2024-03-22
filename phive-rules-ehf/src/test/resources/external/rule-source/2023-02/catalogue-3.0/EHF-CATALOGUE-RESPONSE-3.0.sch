<?xml version="1.0" encoding="UTF-8"?>
<!--

This file is distributed as part of EHF Post-Award G3.

Release: 2022-06-15
Timestamp: 2023-02-15 15:01z

Repository for releases and issues:
  https://github.com/anskaffelser/ehf-postaward-g3
-->
<schema xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:u="utils" schemaVersion="iso" queryBinding="xslt2">

	<title>EHF Catalogue Response 3.0</title>

	<ns prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"/>
	<ns prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"/>
	<ns prefix="ubl" uri="urn:oasis:names:specification:ubl:schema:xsd:ApplicationResponse-2"/>
	<ns prefix="xs" uri="http://www.w3.org/2001/XMLSchema"/>
	<ns prefix="u" uri="utils"/>

	

	<function xmlns="http://www.w3.org/1999/XSL/Transform" name="u:abn" as="xs:boolean">
    <param name="val"/>
    <sequence select="( ((string-to-codepoints(substring($val,1,1)) - 49) * 10) + ((string-to-codepoints(substring($val,2,1)) - 48) * 1) + ((string-to-codepoints(substring($val,3,1)) - 48) * 3) + ((string-to-codepoints(substring($val,4,1)) - 48) * 5) + ((string-to-codepoints(substring($val,5,1)) - 48) * 7) + ((string-to-codepoints(substring($val,6,1)) - 48) * 9) + ((string-to-codepoints(substring($val,7,1)) - 48) * 11) + ((string-to-codepoints(substring($val,8,1)) - 48) * 13) + ((string-to-codepoints(substring($val,9,1)) - 48) * 15) + ((string-to-codepoints(substring($val,10,1)) - 48) * 17) + ((string-to-codepoints(substring($val,11,1)) - 48) * 19)) mod 89 = 0 "/>
</function>
	<function xmlns="http://www.w3.org/1999/XSL/Transform" name="u:addPIVA" as="xs:integer">
    <param name="arg" as="xs:string"/>
    <param name="pari" as="xs:integer"/>
    <variable name="tappo" select="if (not($arg castable as xs:integer)) then 0 else 1"/>
    <variable name="mapper" select="if ($tappo = 0) then 0 else                    ( if ($pari = 1)                     then ( xs:integer(substring('0246813579', ( xs:integer(substring($arg,1,1)) +1 ) ,1)) )                     else ( xs:integer(substring($arg,1,1) ) )                   )"/>
    <sequence select="if ($tappo = 0) then $mapper else ( xs:integer($mapper) + u:addPIVA(substring(xs:string($arg),2), (if($pari=0) then 1 else 0) ) )"/>
  </function>
	<function xmlns="http://www.w3.org/1999/XSL/Transform" name="u:cat2str">
    <param name="cat"/>
    <sequence select="concat(normalize-space($cat/cbc:ID), '-', round(xs:decimal($cat/cbc:Percent) * 1000000))"/>
</function>
	<function xmlns="http://www.w3.org/1999/XSL/Transform" name="u:checkCF" as="xs:boolean">
    <param name="arg" as="xs:string?"/>
    <sequence select="   if ( (string-length($arg) = 16) or (string-length($arg) = 11) )      then    (    if ((string-length($arg) = 16))     then    (     if (u:checkCF16($arg))      then     (      true()     )     else     (      false()     )    )    else    (     if(($arg castable as xs:integer)) then true() else false()       )   )   else   (    false()   )   "/>
  </function>
	<function xmlns="http://www.w3.org/1999/XSL/Transform" name="u:checkCF16" as="xs:boolean">
    <param name="arg" as="xs:string?"/>
    <variable name="allowed-characters">ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz</variable>
    <sequence select="     if (  (string-length(translate(substring($arg,1,6), $allowed-characters, '')) = 0) and         (substring($arg,7,2) castable as xs:integer) and        (string-length(translate(substring($arg,9,1), $allowed-characters, '')) = 0) and        (substring($arg,10,2) castable as xs:integer) and         (substring($arg,12,3) castable as xs:string) and        (substring($arg,15,1) castable as xs:integer) and         (string-length(translate(substring($arg,16,1), $allowed-characters, '')) = 0)      )      then true()     else false()     "/>
  </function>
	<function xmlns="http://www.w3.org/1999/XSL/Transform" name="u:checkCodiceIPA" as="xs:boolean">
    <param name="arg" as="xs:string?"/>
    <variable name="allowed-characters">ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789</variable>
    <sequence select="if ( (string-length(translate($arg, $allowed-characters, '')) = 0) and (string-length($arg) = 6) ) then true() else false()"/>
  </function>
	<function xmlns="http://www.w3.org/1999/XSL/Transform" name="u:checkPIVA" as="xs:integer">
    <param name="arg" as="xs:string?"/>
    <sequence select="     if (not($arg castable as xs:integer))       then 1      else ( u:addPIVA($arg,xs:integer(0)) mod 10 )"/>
  </function>
	<function xmlns="http://www.w3.org/1999/XSL/Transform" name="u:checkPIVAseIT" as="xs:boolean">
    <param name="arg" as="xs:string"/>
    <variable name="paese" select="substring($arg,1,2)"/>
    <variable name="codice" select="substring($arg,3)"/>
    <sequence select="       if ( $paese = 'IT' or $paese = 'it' )    then    (     if ( ( string-length($codice) = 11 ) and ( if (u:checkPIVA($codice)!=0) then false() else true() ))     then      (      true()     )     else     (      false()     )    )    else    (     true()    )      "/>
  </function>
	<function xmlns="http://www.w3.org/1999/XSL/Transform" name="u:gln" as="xs:boolean">
  <param name="val"/>
  <variable name="length" select="string-length($val) - 1"/>
  <variable name="digits" select="reverse(for $i in string-to-codepoints(substring($val, 1, $length)) return $i -48)"/>
  <variable name="weightedSum" select="sum(for $i in (0 to $length - 1) return $digits[$i + 1] * (1 + ((($i + 1) mod 2) * 2)))"/>
  <sequence select="(10 - ($weightedSum mod 10)) mod 10 = number(substring($val, $length + 1, 1))"/>
</function>
	<function xmlns="http://www.w3.org/1999/XSL/Transform" name="u:mod11" as="xs:boolean">
  <param name="val"/>
  <variable name="length" select="string-length($val) - 1"/>
  <variable name="digits" select="reverse(for $i in string-to-codepoints(substring($val, 0, $length + 1)) return $i - 48)"/>
  <variable name="weightedSum" select="sum(for $i in (0 to $length - 1) return $digits[$i + 1] * (($i mod 6) + 2))"/>
  <sequence select="number($val) &gt; 0 and (11 - ($weightedSum mod 11)) mod 11 = number(substring($val, $length + 1, 1))"/>
</function>
	<function xmlns="http://www.w3.org/1999/XSL/Transform" name="u:mod97-0208" as="xs:boolean">
    <param name="val"/>
    <variable name="checkdigits" select="substring($val,9,2)"/>
    <variable name="calculated_digits" select="xs:string(97 - (xs:integer(substring($val,1,8)) mod 97))"/>
    <sequence select="number($checkdigits) = number($calculated_digits)"/>
  </function>
	<function xmlns="http://www.w3.org/1999/XSL/Transform" name="u:slack" as="xs:boolean">
    <param name="exp" as="xs:decimal"/>
    <param name="val" as="xs:decimal"/>
    <param name="slack" as="xs:decimal"/>
    <sequence select="xs:decimal($exp + $slack) &gt;= $val and xs:decimal($exp - $slack) &lt;= $val"/>
</function>

	

	<pattern>
    <rule context="cbc:*">
        <assert id="EHF-COMMON-R001" test=". != ''" flag="fatal">Document MUST not contain empty elements.</assert>
    </rule>

    <rule context="cac:*">
        <assert id="EHF-COMMON-R002" test="count(*) != 0" flag="fatal">Document MUST not contain empty elements.</assert>
    </rule>
</pattern>
	<pattern xmlns:ns2="http://www.schematron-quickfix.com/validator/process"><let name="clICD" value="tokenize('0002 0003 0004 0005 0006 0007 0008 0009 0010 0011 0012 0013 0014 0015 0016 0017 0018 0019 0020 0021 0022 0023 0024 0025 0026 0027 0028 0029 0030 0031 0032 0033 0034 0035 0036 0037 0038 0039 0040 0041 0042 0043 0044 0045 0046 0047 0048 0049 0050 0051 0052 0053 0054 0055 0056 0057 0058 0059 0060 0061 0062 0063 0064 0065 0066 0067 0068 0069 0070 0071 0072 0073 0074 0075 0076 0077 0078 0079 0080 0081 0082 0083 0084 0085 0086 0087 0088 0089 0090 0091 0093 0094 0095 0096 0097 0098 0099 0100 0101 0102 0104 0105 0106 0107 0108 0109 0110 0111 0112 0113 0114 0115 0116 0117 0118 0119 0120 0121 0122 0123 0124 0125 0126 0127 0128 0129 0130 0131 0132 0133 0134 0135 0136 0137 0138 0139 0140 0141 0142 0143 0144 0145 0146 0147 0148 0149 0150 0151 0152 0153 0154 0155 0156 0157 0158 0159 0160 0161 0162 0163 0164 0165 0166 0167 0168 0169 0170 0171 0172 0173 0174 0175 0176 0177 0178 0179 0180 0183 0184 0185 0186 0187 0188 0189 0190 0191 0192 0193 0194 0195 0196 0197 0198 0199 0200 0201 0202 0203 0204 0205 0206 0207 0208 0209 0210 0211 0212 0213 0214 0215 0216', '\s')"/><let name="clUNCL4343" value="tokenize('AB AP RE', '\s')"/><rule context="/ubl:ApplicationResponse"><assert test="cbc:CustomizationID" flag="fatal" id="EHF-T58-B00101">Element 'cbc:CustomizationID' MUST be provided.</assert><assert test="cbc:ProfileID" flag="fatal" id="EHF-T58-B00102">Element 'cbc:ProfileID' MUST be provided.</assert><assert test="cbc:ID" flag="fatal" id="EHF-T58-B00103">Element 'cbc:ID' MUST be provided.</assert><assert test="cbc:IssueDate" flag="fatal" id="EHF-T58-B00104">Element 'cbc:IssueDate' MUST be provided.</assert><assert test="cac:SenderParty" flag="fatal" id="EHF-T58-B00105">Element 'cac:SenderParty' MUST be provided.</assert><assert test="cac:ReceiverParty" flag="fatal" id="EHF-T58-B00106">Element 'cac:ReceiverParty' MUST be provided.</assert><assert test="not(@*:schemaLocation)" flag="fatal" id="EHF-T58-B00107">Document MUST not contain schema location.</assert></rule><rule context="/ubl:ApplicationResponse/cbc:CustomizationID"><assert test="normalize-space(text()) = 'urn:fdc:peppol.eu:poacc:trns:catalogue_response:3:extended:urn:fdc:anskaffelser.no:2019:ehf:spec:3.0'" flag="fatal" id="EHF-T58-B00201">Element 'cbc:CustomizationID' MUST contain value 'urn:fdc:peppol.eu:poacc:trns:catalogue_response:3:extended:urn:fdc:anskaffelser.no:2019:ehf:spec:3.0'.</assert></rule><rule context="/ubl:ApplicationResponse/cbc:CustomizationID/*"><assert test="false()" flag="fatal" id="EHF-T58-B00202">Document MUST NOT contain elements not part of the data model.</assert></rule><rule context="/ubl:ApplicationResponse/cbc:ProfileID"><assert test="normalize-space(text()) = 'urn:fdc:anskaffelser.no:2019:ehf:postaward:g3:01:1.0'" flag="fatal" id="EHF-T58-B00301">Element 'cbc:ProfileID' MUST contain value 'urn:fdc:anskaffelser.no:2019:ehf:postaward:g3:01:1.0'.</assert></rule><rule context="/ubl:ApplicationResponse/cbc:ProfileID/*"><assert test="false()" flag="fatal" id="EHF-T58-B00302">Document MUST NOT contain elements not part of the data model.</assert></rule><rule context="/ubl:ApplicationResponse/cbc:ID"/><rule context="/ubl:ApplicationResponse/cbc:ID/*"><assert test="false()" flag="fatal" id="EHF-T58-B00401">Document MUST NOT contain elements not part of the data model.</assert></rule><rule context="/ubl:ApplicationResponse/cbc:IssueDate"/><rule context="/ubl:ApplicationResponse/cbc:IssueDate/*"><assert test="false()" flag="fatal" id="EHF-T58-B00501">Document MUST NOT contain elements not part of the data model.</assert></rule><rule context="/ubl:ApplicationResponse/cbc:IssueTime"/><rule context="/ubl:ApplicationResponse/cbc:IssueTime/*"><assert test="false()" flag="fatal" id="EHF-T58-B00601">Document MUST NOT contain elements not part of the data model.</assert></rule><rule context="/ubl:ApplicationResponse/cbc:Note"/><rule context="/ubl:ApplicationResponse/cbc:Note/*"><assert test="false()" flag="fatal" id="EHF-T58-B00701">Document MUST NOT contain elements not part of the data model.</assert></rule><rule context="/ubl:ApplicationResponse/cac:SenderParty"><assert test="cbc:EndpointID" flag="fatal" id="EHF-T58-B00801">Element 'cbc:EndpointID' MUST be provided.</assert></rule><rule context="/ubl:ApplicationResponse/cac:SenderParty/cbc:EndpointID"><assert test="not(@schemeID) or @schemeID = '0192'" flag="fatal" id="EHF-T58-B00901">Attribute 'schemeID' MUST contain value '0192'</assert><assert test="@schemeID" flag="fatal" id="EHF-T58-B00902">Attribute 'schemeID' MUST be present.</assert></rule><rule context="/ubl:ApplicationResponse/cac:SenderParty/cbc:EndpointID/*"><assert test="false()" flag="fatal" id="EHF-T58-B00903">Document MUST NOT contain elements not part of the data model.</assert></rule><rule context="/ubl:ApplicationResponse/cac:SenderParty/cac:PartyIdentification"><assert test="cbc:ID" flag="fatal" id="EHF-T58-B01101">Element 'cbc:ID' MUST be provided.</assert></rule><rule context="/ubl:ApplicationResponse/cac:SenderParty/cac:PartyIdentification/cbc:ID"><assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)" flag="fatal" id="EHF-T58-B01201">Value MUST be part of code list 'ISO 6523 ICD list'.</assert></rule><rule context="/ubl:ApplicationResponse/cac:SenderParty/cac:PartyIdentification/cbc:ID/*"><assert test="false()" flag="fatal" id="EHF-T58-B01202">Document MUST NOT contain elements not part of the data model.</assert></rule><rule context="/ubl:ApplicationResponse/cac:SenderParty/cac:PartyIdentification/*"><assert test="false()" flag="fatal" id="EHF-T58-B01102">Document MUST NOT contain elements not part of the data model.</assert></rule><rule context="/ubl:ApplicationResponse/cac:SenderParty/cac:PartyLegalEntity"><assert test="cbc:RegistrationName" flag="fatal" id="EHF-T58-B01401">Element 'cbc:RegistrationName' MUST be provided.</assert></rule><rule context="/ubl:ApplicationResponse/cac:SenderParty/cac:PartyLegalEntity/cbc:RegistrationName"/><rule context="/ubl:ApplicationResponse/cac:SenderParty/cac:PartyLegalEntity/cbc:RegistrationName/*"><assert test="false()" flag="fatal" id="EHF-T58-B01501">Document MUST NOT contain elements not part of the data model.</assert></rule><rule context="/ubl:ApplicationResponse/cac:SenderParty/cac:PartyLegalEntity/*"><assert test="false()" flag="fatal" id="EHF-T58-B01402">Document MUST NOT contain elements not part of the data model.</assert></rule><rule context="/ubl:ApplicationResponse/cac:SenderParty/*"><assert test="false()" flag="fatal" id="EHF-T58-B00802">Document MUST NOT contain elements not part of the data model.</assert></rule><rule context="/ubl:ApplicationResponse/cac:ReceiverParty"><assert test="cbc:EndpointID" flag="fatal" id="EHF-T58-B01601">Element 'cbc:EndpointID' MUST be provided.</assert></rule><rule context="/ubl:ApplicationResponse/cac:ReceiverParty/cbc:EndpointID"><assert test="not(@schemeID) or @schemeID = '0192'" flag="fatal" id="EHF-T58-B01701">Attribute 'schemeID' MUST contain value '0192'</assert><assert test="@schemeID" flag="fatal" id="EHF-T58-B01702">Attribute 'schemeID' MUST be present.</assert></rule><rule context="/ubl:ApplicationResponse/cac:ReceiverParty/cbc:EndpointID/*"><assert test="false()" flag="fatal" id="EHF-T58-B01703">Document MUST NOT contain elements not part of the data model.</assert></rule><rule context="/ubl:ApplicationResponse/cac:ReceiverParty/cac:PartyIdentification"><assert test="cbc:ID" flag="fatal" id="EHF-T58-B01901">Element 'cbc:ID' MUST be provided.</assert></rule><rule context="/ubl:ApplicationResponse/cac:ReceiverParty/cac:PartyIdentification/cbc:ID"><assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)" flag="fatal" id="EHF-T58-B02001">Value MUST be part of code list 'ISO 6523 ICD list'.</assert></rule><rule context="/ubl:ApplicationResponse/cac:ReceiverParty/cac:PartyIdentification/cbc:ID/*"><assert test="false()" flag="fatal" id="EHF-T58-B02002">Document MUST NOT contain elements not part of the data model.</assert></rule><rule context="/ubl:ApplicationResponse/cac:ReceiverParty/cac:PartyIdentification/*"><assert test="false()" flag="fatal" id="EHF-T58-B01902">Document MUST NOT contain elements not part of the data model.</assert></rule><rule context="/ubl:ApplicationResponse/cac:ReceiverParty/cac:PartyLegalEntity"><assert test="cbc:RegistrationName" flag="fatal" id="EHF-T58-B02201">Element 'cbc:RegistrationName' MUST be provided.</assert></rule><rule context="/ubl:ApplicationResponse/cac:ReceiverParty/cac:PartyLegalEntity/cbc:RegistrationName"/><rule context="/ubl:ApplicationResponse/cac:ReceiverParty/cac:PartyLegalEntity/cbc:RegistrationName/*"><assert test="false()" flag="fatal" id="EHF-T58-B02301">Document MUST NOT contain elements not part of the data model.</assert></rule><rule context="/ubl:ApplicationResponse/cac:ReceiverParty/cac:PartyLegalEntity/*"><assert test="false()" flag="fatal" id="EHF-T58-B02202">Document MUST NOT contain elements not part of the data model.</assert></rule><rule context="/ubl:ApplicationResponse/cac:ReceiverParty/*"><assert test="false()" flag="fatal" id="EHF-T58-B01602">Document MUST NOT contain elements not part of the data model.</assert></rule><rule context="/ubl:ApplicationResponse/cac:DocumentResponse"><assert test="cac:Response" flag="fatal" id="EHF-T58-B02401">Element 'cac:Response' MUST be provided.</assert><assert test="cac:DocumentReference" flag="fatal" id="EHF-T58-B02402">Element 'cac:DocumentReference' MUST be provided.</assert></rule><rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:Response"><assert test="cbc:ResponseCode" flag="fatal" id="EHF-T58-B02501">Element 'cbc:ResponseCode' MUST be provided.</assert></rule><rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:Response/cbc:ResponseCode"><assert test="(some $code in $clUNCL4343 satisfies $code = normalize-space(text()))" flag="fatal" id="EHF-T58-B02601">Value MUST be part of code list 'Application Response type code (UNCL4343 Subset)'.</assert></rule><rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:Response/cbc:ResponseCode/*"><assert test="false()" flag="fatal" id="EHF-T58-B02602">Document MUST NOT contain elements not part of the data model.</assert></rule><rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:Response/*"><assert test="false()" flag="fatal" id="EHF-T58-B02502">Document MUST NOT contain elements not part of the data model.</assert></rule><rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:DocumentReference"><assert test="cbc:ID" flag="fatal" id="EHF-T58-B02701">Element 'cbc:ID' MUST be provided.</assert></rule><rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:DocumentReference/cbc:ID"/><rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:DocumentReference/cbc:ID/*"><assert test="false()" flag="fatal" id="EHF-T58-B02801">Document MUST NOT contain elements not part of the data model.</assert></rule><rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:DocumentReference/cbc:VersionID"/><rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:DocumentReference/cbc:VersionID/*"><assert test="false()" flag="fatal" id="EHF-T58-B02901">Document MUST NOT contain elements not part of the data model.</assert></rule><rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:DocumentReference/*"><assert test="false()" flag="fatal" id="EHF-T58-B02702">Document MUST NOT contain elements not part of the data model.</assert></rule><rule context="/ubl:ApplicationResponse/cac:DocumentResponse/*"><assert test="false()" flag="fatal" id="EHF-T58-B02403">Document MUST NOT contain elements not part of the data model.</assert></rule><rule context="/ubl:ApplicationResponse/*"><assert test="false()" flag="fatal" id="EHF-T58-B00108">Document MUST NOT contain elements not part of the data model.</assert></rule></pattern>
	<pattern>

    

    <rule context="cbc:EndpointID[@schemeID = '0192'] | cac:PartyIdentification/cbc:ID[@schemeID = '0192'] | cbc:CompanyID[@schemeID = '0192']">
        <assert id="EHF-COMMON-R003" test="matches(normalize-space(), '^[0-9]{9}$') and u:mod11(normalize-space())" flag="fatal">MUST be a valid Norwegian organization number. Only numerical value allowed</assert>
    </rule>

    

    <rule context="/*">
        <assert id="PEPPOL-COMMON-R003" test="not(@*:schemaLocation)" flag="warning">Document SHOULD not contain schema location.</assert>

    </rule>

    <rule context="cbc:IssueDate | cbc:DueDate | cbc:TaxPointDate | cbc:StartDate | cbc:EndDate | cbc:ActualDeliveryDate">
        <assert id="PEPPOL-COMMON-R030" test="(string(.) castable as xs:date) and (string-length(.) = 10)" flag="fatal">A date must be formatted YYYY-MM-DD.</assert>
    </rule>
    <rule context="cbc:EndpointID[@schemeID = '0088'] | cac:PartyIdentification/cbc:ID[@schemeID = '0088'] | cbc:CompanyID[@schemeID = '0088']">
        <assert id="PEPPOL-COMMON-R040" test="matches(normalize-space(), '^[0-9]+$') and u:gln(normalize-space())" flag="fatal">GLN must have a valid format according to GS1 rules.</assert>
    </rule>
    <rule context="cbc:EndpointID[@schemeID = '0208'] | cac:PartyIdentification/cbc:ID[@schemeID = '0208'] | cbc:CompanyID[@schemeID = '0208']">
      <assert id="PEPPOL-COMMON-R043" test="matches(normalize-space(), '^[0-9]{10}$') and u:mod97-0208(normalize-space())" flag="fatal">Belgian enterprise number MUST be stated in the correct format.</assert>
    </rule>	
    <rule context="cbc:EndpointID[@schemeID = '0201'] | cac:PartyIdentification/cbc:ID[@schemeID = '0201'] | cbc:CompanyID[@schemeID = '0201']">
      <assert id="PEPPOL-COMMON-R044" test="u:checkCodiceIPA(normalize-space())" flag="warning">IPA Code (Codice Univoco Unità Organizzativa) must be stated in the correct format</assert>
    </rule>
    <rule context="cbc:EndpointID[@schemeID = '0210'] | cac:PartyIdentification/cbc:ID[@schemeID = '0210'] | cbc:CompanyID[@schemeID = '0210']">
      <assert id="PEPPOL-COMMON-R045" test="u:checkCF(normalize-space())" flag="warning">Tax Code (Codice Fiscale) must be stated in the correct format</assert>
    </rule>
    <rule context="cbc:EndpointID[@schemeID = '9907']">
      <assert id="PEPPOL-COMMON-R046" test="u:checkCF(normalize-space())" flag="warning">Tax Code (Codice Fiscale) must be stated in the correct format</assert>
    </rule>
    <rule context="cbc:EndpointID[@schemeID = '0211'] | cac:PartyIdentification/cbc:ID[@schemeID = '0211'] | cbc:CompanyID[@schemeID = '0211']">
      <assert id="PEPPOL-COMMON-R047" test="u:checkPIVAseIT(normalize-space())" flag="warning">Italian VAT Code (Partita Iva) must be stated in the correct format</assert>
    </rule>
    <rule context="cbc:EndpointID[@schemeID = '9906']">
      <assert id="PEPPOL-COMMON-R048" test="u:checkPIVAseIT(normalize-space())" flag="warning">Italian VAT Code (Partita Iva) must be stated in the correct format</assert>
    </rule>
    <rule context="cbc:EndpointID[@schemeID = '0007'] | cac:PartyIdentification/cbc:ID[@schemeID = '0007'] | cbc:CompanyID[@schemeID = '0007']">
      <assert id="PEPPOL-COMMON-R049" test="string-length(normalize-space()) = 10 and string(number(normalize-space())) != 'NaN'" flag="warning">Swedish organization number MUST be stated in the correct format.</assert>     
    </rule> 
    <rule context="cbc:EndpointID[@schemeID = '0151'] | cac:PartyIdentification/cbc:ID[@schemeID = '0151'] | cbc:CompanyID[@schemeID = '0151']">
      <assert id="PEPPOL-COMMON-R050" test="u:abn(normalize-space())" flag="warning">Australian Business Number (ABN) MUST be stated in the correct format.</assert>
    </rule>

  </pattern>
	

</schema>