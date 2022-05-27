<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<xsl:stylesheet xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" xmlns:ccts="urn:oasis:names:specification:ubl:schema:xsd:CoreComponentParameters-2" xmlns:doc="urn:oasis:names:specification:ubl:schema:xsd:Reminder-2" xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2" xmlns:iso="http://purl.oclc.org/dsdl/schematron" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:sdt="urn:oasis:names:specification:ubl:schema:xsd:SpecializedDatatypes-2" xmlns:udt="urn:un:unece:uncefact:data:specification:UnqualifiedDataTypesSchemaModule:2" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
<!--Implementers: please note that overriding process-prolog or process-root is 
    the preferred method for meta-stylesheets to use where possible. -->

<xsl:param name="archiveDirParameter" />
  <xsl:param name="archiveNameParameter" />
  <xsl:param name="fileNameParameter" />
  <xsl:param name="fileDirParameter" />
  <xsl:variable name="document-uri">
    <xsl:value-of select="document-uri(/)" />
  </xsl:variable>

<!--PHASES-->


<!--PROLOG-->
<xsl:output indent="yes" method="xml" omit-xml-declaration="no" standalone="yes" />

<!--XSD TYPES FOR XSLT2-->


<!--KEYS AND FUNCTIONS-->


<!--DEFAULT RULES-->


<!--MODE: SCHEMATRON-SELECT-FULL-PATH-->
<!--This mode can be used to generate an ugly though full XPath for locators-->
<xsl:template match="*" mode="schematron-select-full-path">
    <xsl:apply-templates mode="schematron-get-full-path" select="." />
  </xsl:template>

<!--MODE: SCHEMATRON-FULL-PATH-->
<!--This mode can be used to generate an ugly though full XPath for locators-->
<xsl:template match="*" mode="schematron-get-full-path">
    <xsl:apply-templates mode="schematron-get-full-path" select="parent::*" />
    <xsl:text>/</xsl:text>
    <xsl:choose>
      <xsl:when test="namespace-uri()=''">
        <xsl:value-of select="name()" />
        <xsl:variable name="p_1" select="1+    count(preceding-sibling::*[name()=name(current())])" />
        <xsl:if test="$p_1>1 or following-sibling::*[name()=name(current())]">[<xsl:value-of select="$p_1" />]</xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>*[local-name()='</xsl:text>
        <xsl:value-of select="local-name()" />
        <xsl:text>']</xsl:text>
        <xsl:variable name="p_2" select="1+   count(preceding-sibling::*[local-name()=local-name(current())])" />
        <xsl:if test="$p_2>1 or following-sibling::*[local-name()=local-name(current())]">[<xsl:value-of select="$p_2" />]</xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="@*" mode="schematron-get-full-path">
    <xsl:text>/</xsl:text>
    <xsl:choose>
      <xsl:when test="namespace-uri()=''">@<xsl:value-of select="name()" />
</xsl:when>
      <xsl:otherwise>
        <xsl:text>@*[local-name()='</xsl:text>
        <xsl:value-of select="local-name()" />
        <xsl:text>' and namespace-uri()='</xsl:text>
        <xsl:value-of select="namespace-uri()" />
        <xsl:text>']</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

<!--MODE: SCHEMATRON-FULL-PATH-2-->
<!--This mode can be used to generate prefixed XPath for humans-->
<xsl:template match="node() | @*" mode="schematron-get-full-path-2">
    <xsl:for-each select="ancestor-or-self::*">
      <xsl:text>/</xsl:text>
      <xsl:value-of select="name(.)" />
      <xsl:if test="preceding-sibling::*[name(.)=name(current())]">
        <xsl:text>[</xsl:text>
        <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />
        <xsl:text>]</xsl:text>
      </xsl:if>
    </xsl:for-each>
    <xsl:if test="not(self::*)">
      <xsl:text />/@<xsl:value-of select="name(.)" />
    </xsl:if>
  </xsl:template>
<!--MODE: SCHEMATRON-FULL-PATH-3-->
<!--This mode can be used to generate prefixed XPath for humans 
	(Top-level element has index)-->

<xsl:template match="node() | @*" mode="schematron-get-full-path-3">
    <xsl:for-each select="ancestor-or-self::*">
      <xsl:text>/</xsl:text>
      <xsl:value-of select="name(.)" />
      <xsl:if test="parent::*">
        <xsl:text>[</xsl:text>
        <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />
        <xsl:text>]</xsl:text>
      </xsl:if>
    </xsl:for-each>
    <xsl:if test="not(self::*)">
      <xsl:text />/@<xsl:value-of select="name(.)" />
    </xsl:if>
  </xsl:template>

<!--MODE: GENERATE-ID-FROM-PATH -->
<xsl:template match="/" mode="generate-id-from-path" />
  <xsl:template match="text()" mode="generate-id-from-path">
    <xsl:apply-templates mode="generate-id-from-path" select="parent::*" />
    <xsl:value-of select="concat('.text-', 1+count(preceding-sibling::text()), '-')" />
  </xsl:template>
  <xsl:template match="comment()" mode="generate-id-from-path">
    <xsl:apply-templates mode="generate-id-from-path" select="parent::*" />
    <xsl:value-of select="concat('.comment-', 1+count(preceding-sibling::comment()), '-')" />
  </xsl:template>
  <xsl:template match="processing-instruction()" mode="generate-id-from-path">
    <xsl:apply-templates mode="generate-id-from-path" select="parent::*" />
    <xsl:value-of select="concat('.processing-instruction-', 1+count(preceding-sibling::processing-instruction()), '-')" />
  </xsl:template>
  <xsl:template match="@*" mode="generate-id-from-path">
    <xsl:apply-templates mode="generate-id-from-path" select="parent::*" />
    <xsl:value-of select="concat('.@', name())" />
  </xsl:template>
  <xsl:template match="*" mode="generate-id-from-path" priority="-0.5">
    <xsl:apply-templates mode="generate-id-from-path" select="parent::*" />
    <xsl:text>.</xsl:text>
    <xsl:value-of select="concat('.',name(),'-',1+count(preceding-sibling::*[name()=name(current())]),'-')" />
  </xsl:template>

<!--MODE: GENERATE-ID-2 -->
<xsl:template match="/" mode="generate-id-2">U</xsl:template>
  <xsl:template match="*" mode="generate-id-2" priority="2">
    <xsl:text>U</xsl:text>
    <xsl:number count="*" level="multiple" />
  </xsl:template>
  <xsl:template match="node()" mode="generate-id-2">
    <xsl:text>U.</xsl:text>
    <xsl:number count="*" level="multiple" />
    <xsl:text>n</xsl:text>
    <xsl:number count="node()" />
  </xsl:template>
  <xsl:template match="@*" mode="generate-id-2">
    <xsl:text>U.</xsl:text>
    <xsl:number count="*" level="multiple" />
    <xsl:text>_</xsl:text>
    <xsl:value-of select="string-length(local-name(.))" />
    <xsl:text>_</xsl:text>
    <xsl:value-of select="translate(name(),':','.')" />
  </xsl:template>
<!--Strip characters-->  <xsl:template match="text()" priority="-1" />

<!--SCHEMA SETUP-->
<xsl:template match="/">
    <svrl:schematron-output schemaVersion="" title="Checking OIOUBL-2.1 Reminder">
      <xsl:comment>
        <xsl:value-of select="$archiveDirParameter" />   
		 <xsl:value-of select="$archiveNameParameter" />  
		 <xsl:value-of select="$fileNameParameter" />  
		 <xsl:value-of select="$fileDirParameter" />
      </xsl:comment>
      <svrl:text>Schematron for validating OIOUBL-2.1 documents.</svrl:text>
      <svrl:ns-prefix-in-attribute-values prefix="doc" uri="urn:oasis:names:specification:ubl:schema:xsd:Reminder-2" />
      <svrl:ns-prefix-in-attribute-values prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" />
      <svrl:ns-prefix-in-attribute-values prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" />
      <svrl:ns-prefix-in-attribute-values prefix="ccts" uri="urn:oasis:names:specification:ubl:schema:xsd:CoreComponentParameters-2" />
      <svrl:ns-prefix-in-attribute-values prefix="sdt" uri="urn:oasis:names:specification:ubl:schema:xsd:SpecializedDatatypes-2" />
      <svrl:ns-prefix-in-attribute-values prefix="udt" uri="urn:un:unece:uncefact:data:specification:UnqualifiedDataTypesSchemaModule:2" />
      <svrl:ns-prefix-in-attribute-values prefix="ext" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2" />
      <svrl:ns-prefix-in-attribute-values prefix="xs" uri="http://www.w3.org/2001/XMLSchema" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">abstracts2</xsl:attribute>
        <xsl:attribute name="name">abstracts2</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M10" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">abstracts</xsl:attribute>
        <xsl:attribute name="name">abstracts</xsl:attribute>
        <svrl:text>Pattern for storing abstract rules</svrl:text>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M12" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">ublextensions</xsl:attribute>
        <xsl:attribute name="name">ublextensions</xsl:attribute>
        <svrl:text>Pattern for validating the UBLExtensions class</svrl:text>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M13" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">profile</xsl:attribute>
        <xsl:attribute name="name">profile</xsl:attribute>
        <svrl:text>Pattern for validating root element, Profile and UBL version</svrl:text>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M14" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">reminder</xsl:attribute>
        <xsl:attribute name="name">reminder</xsl:attribute>
        <svrl:text>Pattern for validating the Reminder structure</svrl:text>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M15" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">reminderperiod</xsl:attribute>
        <xsl:attribute name="name">reminderperiod</xsl:attribute>
        <svrl:text>Pattern for validating the ReminderPeriod class</svrl:text>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M16" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">additionaldocumentreference</xsl:attribute>
        <xsl:attribute name="name">additionaldocumentreference</xsl:attribute>
        <svrl:text>Pattern for validating the AdditionalDocumentReference class</svrl:text>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M17" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">signature</xsl:attribute>
        <xsl:attribute name="name">signature</xsl:attribute>
        <svrl:text>Pattern for validating the Signature class</svrl:text>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M18" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">accountingsupplierparty</xsl:attribute>
        <xsl:attribute name="name">accountingsupplierparty</xsl:attribute>
        <svrl:text>Pattern for validating the AccountingSupplierParty class</svrl:text>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M19" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">accountingcustomerparty</xsl:attribute>
        <xsl:attribute name="name">accountingcustomerparty</xsl:attribute>
        <svrl:text>Pattern for validating the AccountingCustomerParty class</svrl:text>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M20" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">payeeparty</xsl:attribute>
        <xsl:attribute name="name">payeeparty</xsl:attribute>
        <svrl:text>Pattern for validating the PayeeParty class</svrl:text>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M21" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">taxRepresentativeParty</xsl:attribute>
        <xsl:attribute name="name">taxRepresentativeParty</xsl:attribute>
        <svrl:text>Pattern for validating the TaxRepresentativeParty class</svrl:text>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M22" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">paymentmeans</xsl:attribute>
        <xsl:attribute name="name">paymentmeans</xsl:attribute>
        <svrl:text>Pattern for validating the PaymentMeans class</svrl:text>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M23" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">paymentterms</xsl:attribute>
        <xsl:attribute name="name">paymentterms</xsl:attribute>
        <svrl:text>Pattern for validating the PaymentTerms class</svrl:text>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M24" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">prepaidpayment</xsl:attribute>
        <xsl:attribute name="name">prepaidpayment</xsl:attribute>
        <svrl:text>Pattern for validating the PrepaidPayment class</svrl:text>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M25" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">allowancecharge</xsl:attribute>
        <xsl:attribute name="name">allowancecharge</xsl:attribute>
        <svrl:text>Pattern for validating the AllowanceCharge class</svrl:text>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M27" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">taxexchangerate</xsl:attribute>
        <xsl:attribute name="name">taxexchangerate</xsl:attribute>
        <svrl:text>Pattern for validating the TaxExchangeRate class</svrl:text>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M28" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">pricingexchangerate</xsl:attribute>
        <xsl:attribute name="name">pricingexchangerate</xsl:attribute>
        <svrl:text>Pattern for validating the PricingExchangeRate class</svrl:text>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M29" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">paymentexchangerate</xsl:attribute>
        <xsl:attribute name="name">paymentexchangerate</xsl:attribute>
        <svrl:text>Pattern for validating the PaymentExchangeRate class</svrl:text>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M30" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">paymentalternativeexchangerate</xsl:attribute>
        <xsl:attribute name="name">paymentalternativeexchangerate</xsl:attribute>
        <svrl:text>Pattern for validating the PaymentAlternativeExchangeRate class</svrl:text>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M31" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">taxtotal</xsl:attribute>
        <xsl:attribute name="name">taxtotal</xsl:attribute>
        <svrl:text>Pattern for validating the TaxTotal class</svrl:text>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M32" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">legalmonetarytotal</xsl:attribute>
        <xsl:attribute name="name">legalmonetarytotal</xsl:attribute>
        <svrl:text>Pattern for validating the LegalMonetaryTotal class</svrl:text>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M33" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">reminderline</xsl:attribute>
        <xsl:attribute name="name">reminderline</xsl:attribute>
        <svrl:text>Pattern for validating the ReminderLine class</svrl:text>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M34" select="/" />
    </svrl:schematron-output>
  </xsl:template>

<!--SCHEMATRON PATTERNS-->
<svrl:text>Checking OIOUBL-2.1 Reminder</svrl:text>

<!--PATTERN abstracts2-->
<xsl:variable name="AccountType" select="',1,2,3,'" />
  <xsl:variable name="AccountType_listID" select="'urn:oioubl:codelist:accounttypecode-1.1'" />
  <xsl:variable name="AccountType_agencyID" select="'320'" />
  <xsl:variable name="UN_AddressFormat" select="',1,2,3,4,5,6,7,8,9,'" />
  <xsl:variable name="UN_AddressFormat_listID" select="'UN/ECE 3477'" />
  <xsl:variable name="UN_AddressFormat_agencyID" select="'6'" />
  <xsl:variable name="AddressFormat" select="',StructuredDK,StructuredID,StructuredLax,StructuredRegion,Unstructured,'" />
  <xsl:variable name="AddressFormat_listID" select="'urn:oioubl:codelist:addressformatcode-1.1'" />
  <xsl:variable name="AddressFormat_agencyID" select="'320'" />
  <xsl:variable name="AddressType" select="',Home,Business,'" />
  <xsl:variable name="AddressType_listID" select="'urn:oioubl:codelist:addresstypecode-1.1'" />
  <xsl:variable name="AddressType_agencyID" select="'320'" />
  <xsl:variable name="Allowance" select="',1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,ZZZ,'" />
  <xsl:variable name="Allowance_listID" select="'UN/ECE 4465'" />
  <xsl:variable name="Allowance_agencyID" select="'6'" />
  <xsl:variable name="CatDocType" select="',Brochure,Drawing,Picture,ProductSheet,'" />
  <xsl:variable name="CatDocType_listID" select="'urn:oioubl:codelist:cataloguedocumenttypecode-1.1'" />
  <xsl:variable name="CatDocType_agencyID" select="'320'" />
  <xsl:variable name="CatDocType2" select="',Brochure,Drawing,Picture,ProductSheet,PictureURL,'" />
  <xsl:variable name="CatDocType2_listID2" select="'urn:oioubl:codelist:cataloguedocumenttypecode-1.2'" />
  <xsl:variable name="CatAction" select="',Update,Delete,Add,'" />
  <xsl:variable name="CatAction_listID" select="'urn:oioubl:codelist:catalogueactioncode-1.1'" />
  <xsl:variable name="CatAction_agencyID" select="'320'" />
  <xsl:variable name="CountryCode" select="',AD,AE,AF,AG,AI,AL,AM,AO,AQ,AR,AS,AT,AU,AW,AX,AZ,BA,BB,BD,BE,BF,BG,BH,BI,BJ,BM,BN,BO,BQ,BR,BS,BT,BV,BW,BY,BZ,CA,CC,CD,CF,CG,CH,CI,CK,CL,CM,CN,CO,CR,CU,CV,CW,CX,CY,CZ,DE,DJ,DK,DM,DO,DZ,EC,EE,EG,EH,ER,ES,ET,FI,FJ,FK,FM,FO,FR,GA,GB,GD,GE,GF,GG,GH,GI,GL,GM,GN,GP,GQ,GR,GS,GT,GU,GW,GY,HK,HM,HN,HR,HT,HU,ID,IE,IL,IM,IN,IO,IQ,IR,IS,IT,JE,JM,JO,JP,KE,KG,KH,KI,KM,KN,KP,KR,KW,KY,KZ,LA,LB,LC,LI,LK,LR,LS,LT,LU,LV,LY,MA,MC,MD,ME,MG,MH,MK,ML,MM,MN,MO,MP,MQ,MR,MS,MT,MU,MV,MW,MX,MY,MZ,NA,NC,NE,NF,NG,NI,NL,NO,NP,NR,NU,NZ,OM,PA,PE,PF,PG,PH,PK,PL,PM,PN,PR,PS,PT,PW,PY,QA,RE,RO,RS,RU,RW,SA,SB,SC,SD,SE,SG,SH,SI,SJ,SK,SL,SM,SN,SO,SR,SS,ST,SV,SX,SY,SZ,TC,TD,TF,TG,TH,TJ,TK,TL,TM,TN,TO,TR,TT,TV,TW,TZ,UA,UG,UM,US,UY,UZ,VA,VC,VE,VG,VI,VN,VU,WF,WS,YE,YT,ZA,ZM,ZW,'" />
  <xsl:variable name="CountryCode_listID" select="'ISO3166-2'" />
  <xsl:variable name="CountryCode_agencyID" select="'6'" />
  <xsl:variable name="CountrySub" select="',DK-81,'" />
  <xsl:variable name="CountrySub_listID" select="'ISO 3166-2'" />
  <xsl:variable name="CountrySub_agencyID" select="'6'" />
  <xsl:variable name="CurrencyCode" select="',EUR,AFA,DZD,ADP,ARS,AMD,AWG,AUD,AZM,BSD,BHD,THB,PAB,BBD,BYB,BYR,BEF,BZD,BMD,VEB,BOB,BRL,BND,BGN,BIF,CAD,CVE,KYD,GHC,XOF,XAF,XPF,CLP,COP,KMF,BAM,NIO,CRC,HRK,CUP,CYP,CZK,GMD,DKK,MKD,DEM,DJF,STD,DOP,VND,GRD,XCD,EGP,SVC,ETB,FKP,FJD,HUF,CDF,FRF,GIP,HTG,PYG,GNF,GWP,GYD,HKD,UAH,ISK,INR,IRR,IQD,IEP,ITL,JMD,JOD,KES,PGK,LAK,EEK,KWD,MWK,ZMK,AOA,MMK,GEL,LVL,LBP,ALL,HNL,SLL,ROL,BGL,LRD,LYD,SZL,LTL,LSL,LUF,MGF,MYR,MTL,TMM,FIM,MUR,MZM,MXN,MXV,MDL,MAD,BOV,NGN,ERN,NAD,NPR,ANG,NLG,ILS,TWD,NZD,BTN,KPW,NOK,PEN,MRO,TOP,PKR,MOP,UYU,PHP,PTE,GBP,BWP,QAR,GTQ,ZAR,OMR,KHR,MVR,IDR,RUB,RUR,RWF,SHP,SAR,ATS,XDR,SCR,SGD,SKK,SBD,KGS,SOS,ESP,LKR,SDD,SRG,SEK,CHF,SYP,TJR,BDT,WST,TZS,KZT,TPE,SIT,TTD,MNT,TND,TRL,AED,UGX,CLF,USD,UZS,VUV,KRW,YER,JPY,CNY,YUM,ZWD,PLN,AFA,DZD,ADP,ARS,AMD,AWG,AUD,AZM,BSD,BHD,THB,PAB,BBD,BYB,BYR,BEF,BZD,BMD,VEB,BOB,BRL,BND,BGN,'" />
  <xsl:variable name="CurrencyCode_listID" select="'ISO 4217 Alpha'" />
  <xsl:variable name="CurrencyCode_agencyID" select="'6'" />
  <xsl:variable name="Discrepancy" select="',Billing1,Billing2,Billing3,Condition1,Condition2,Condition3,Condition4,Condition5,Condition6,Delivery1,Delivery2,Delivery3,Quality1,Quality2,ZZZ,'" />
  <xsl:variable name="Discrepancy_listID" select="'urn:oioubl:codelist:discrepancyresponsecode-1.1'" />
  <xsl:variable name="Discrepancy_agencyID" select="'320'" />
  <xsl:variable name="DocTypeCode" select="'rule'" />
  <xsl:variable name="DocTypeCode_listID" select="'UN/ECE 1001'" />
  <xsl:variable name="DocTypeCode_agencyID" select="'6'" />
  <xsl:variable name="InvTypeCode" select="',325,380,393,'" />
  <xsl:variable name="InvTypeCode_listID" select="'urn:oioubl:codelist:invoicetypecode-1.1'" />
  <xsl:variable name="InvTypeCode_agencyID" select="'320'" />
  <xsl:variable name="InvTypeCode2" select="',325,380,390,393,'" />
  <xsl:variable name="InvTypeCode2_listID" select="'urn:oioubl:codelist:invoicetypecode-1.2'" />
  <xsl:variable name="UNSPSC" select="'rule'" />
  <xsl:variable name="UNSPSC_listID" select="'UNSPSC'" />
  <xsl:variable name="UNSPSC_agencyID" select="'113'" />
  <xsl:variable name="LifeCycle" select="',Available,DeletedAnnouncement,ItemDeleted,NewAnnouncement,NewAvailable,ItemTemporarilyUnavailable,'" />
  <xsl:variable name="LifeCycle_listID" select="'urn:oioubl:codelist:lifecyclestatuscode-1.1'" />
  <xsl:variable name="LifeCycle_agencyID" select="'320'" />
  <xsl:variable name="LineResponse" select="',BusinessAccept,BusinessReject,'" />
  <xsl:variable name="LineResponse_listID" select="'urn:oioubl:codelist:lineresponsecode-1.1'" />
  <xsl:variable name="LineResponse_agencyID" select="'320'" />
  <xsl:variable name="LineStatus" select="',Added,Cancelled,Disputed,NoStatus,Revised,'" />
  <xsl:variable name="LineStatus_listID" select="'urn:oioubl:codelist:linestatuscode-1.1'" />
  <xsl:variable name="LineStatus_agencyID" select="'320'" />
  <xsl:variable name="LossRisk" select="',FOB,'" />
  <xsl:variable name="LossRisk_listID" select="'urn:oioubl:codelist:lossriskresponsibilitycode-1.1'" />
  <xsl:variable name="LossRisk_agencyID" select="'320'" />
  <xsl:variable name="PaymentChannel" select="',BBAN,DK:BANK,DK:FIK,DK:GIRO,DK:NEMKONTO,FI:BANK,FI:GIRO,GB:BACS,GB:BANK,GB:GIRO,IBAN,IS:BANK,IS:GIRO,IS:IK66,IS:RB,NO:BANK,SE:BANKGIRO,SE:PLUSGIRO,SWIFTUS,ZZZ,'" />
  <xsl:variable name="PaymentChannel_listID" select="'urn:oioubl:codelist:paymentchannelcode-1.1'" />
  <xsl:variable name="PaymentChannel_agencyID" select="'320'" />
  <xsl:variable name="PriceType" select="',AAA,AAB,AAC,AAD,AAE,AAF,AAG,AAH,AAI,AAJ,AAK,AAL,AAM,AAN,AAO,AAP,AAQ,AAR,AAS,AAT,AAU,AAV,AAW,AAX,AAY,AAZ,ABA,ABB,ABC,ABD,ABE,ABF,ABG,ABH,ABI,ABJ,ABK,ABL,ABM,ABN,ABO,ABP,ABQ,ABR,ABS,ABT,ABU,ABV,AI,ALT,AP,BR,CAT,CDV,CON,CP,CU,CUP,CUS,DAP,DIS,DPR,DR,DSC,EC,ES,EUP,FCR,GRP,INV,LBL,MAX,MIN,MNR,MSR,MXR,NE,NQT,NTP,NW,OCR,OFR,PAQ,PBQ,PPD,PPR,PRO,PRP,PW,QTE,RES,RTP,SHD,SRP,SW,TB,TRF,TU,TW,WH,'" />
  <xsl:variable name="PriceType_listID" select="'UN/ECE 5387'" />
  <xsl:variable name="PriceType_agencyID" select="'6'" />
  <xsl:variable name="PriceListStat" select="',Original,Copy,Revision,Cancellation,'" />
  <xsl:variable name="PriceListStat_listID" select="'urn:oioubl.codelist:priceliststatuscode-1.1,urn:oioubl:codelist:priceliststatuscode-1.1'" />
  <xsl:variable name="PriceListStat_agencyID" select="'320'" />
  <xsl:variable name="RemType" select="',Reminder,Advis,'" />
  <xsl:variable name="RemType_listID" select="',urn:oioubl.codelist:remindertypecode-1.1,urn:oioubl:codelist:remindertypecode-1.1,'" />
  <xsl:variable name="RemType_agencyID" select="'320'" />
  <xsl:variable name="RemAlc" select="',PenaltyFee,PenaltyRate,'" />
  <xsl:variable name="RemAlc_listID" select="'urn:oioubl:codelist:reminderallowancechargereasoncode-1.0'" />
  <xsl:variable name="RemAlc_agencyID" select="'320'" />
  <xsl:variable name="Response" select="',BusinessAccept,BusinessReject,ProfileAccept,ProfileReject,TechnicalAccept,TechnicalReject,'" />
  <xsl:variable name="Response_listID" select="'urn:oioubl:codelist:responsecode-1.1'" />
  <xsl:variable name="Response_agencyID" select="'320'" />
  <xsl:variable name="ResponseDocType" select="',ApplicationResponse,Catalogue,CatalogueDeletion,CatalogueItemSpecificationUpdate,CatalogueItemUpdate,CataloguePricingUpdate,CataloguePriceUpdate,CatalogueRequest,CreditNote,Invoice,Order,OrderCancellation,OrderChange,OrderResponse,OrderResponseSimple,Reminder,Statement,Payment,PersonalSecure,ZZZ,'" />
  <xsl:variable name="ResponseDocType_listID" select="'urn:oioubl:codelist:responsedocumenttypecode-1.1'" />
  <xsl:variable name="ResponseDocType_agencyID" select="'320'" />
  <xsl:variable name="ResponseDocType2" select="',ApplicationResponse,Catalogue,CatalogueDeletion,CatalogueItemSpecificationUpdate,CatalogueItemUpdate,CataloguePricingUpdate,CataloguePriceUpdate,CatalogueRequest,CreditNote,Invoice,Order,OrderCancellation,OrderChange,OrderResponse,OrderResponseSimple,Reminder,Statement,Payment,UtilityStatement,PersonalSecure,ZZZ,'" />
  <xsl:variable name="ResponseDocType2_listID" select="'urn:oioubl:codelist:responsedocumenttypecode-1.2'" />
  <xsl:variable name="ResponseDocType2_agencyID" select="'320'" />
  <xsl:variable name="SubStatus" select="',DeliveryDateChanged,DeliveryDateNotPossible,DeliveryPartyUnknown,ItemDeleted,ItemNotFound,ItemNotInAssortment,ItemReplaced,ItemTemporarilyUnavailable,NewAnnouncement,OrderedQuantityChanged,OrderLineRejected,Original,SeasonalItemUnavailable,Substitution,'" />
  <xsl:variable name="SubStatus_listID" select="'urn:oioubl:codelist:substitutionstatuscode-1.1'" />
  <xsl:variable name="SubStatus_agencyID" select="'320'" />
  <xsl:variable name="TaxExemption" select="',AAA,AAB,AAC,AAE,AAF,AAG,AAH,AAI,AAJ,AAK,AAL,AAM,AAN,AAO,'" />
  <xsl:variable name="TaxExemption_listID" select="'CWA 15577'" />
  <xsl:variable name="TaxExemption_agencyID" select="'CEN'" />
  <xsl:variable name="TaxType" select="',StandardRated,ZeroRated,'" />
  <xsl:variable name="TaxType_listID" select="'urn:oioubl:codelist:taxtypecode-1.1'" />
  <xsl:variable name="TaxType_agencyID" select="'320'" />
  <xsl:variable name="TaxType2" select="',StandardRated,ZeroRated,ReverseCharge,'" />
  <xsl:variable name="TaxType_listID2" select="'urn:oioubl:codelist:taxtypecode-1.2'" />
  <xsl:variable name="UnitMeasure" select="'xsd'" />
  <xsl:variable name="UnitMeasure_listID" select="'UN/ECE rec 20'" />
  <xsl:variable name="UnitMeasure_agencyID" select="'6'" />
  <xsl:variable name="UtilityStatType" select="',MultiSettlement,Internet,Television,Fibernet,Lighting,OutdoorLighting,Cooling,DistantCooling,ChimneySweep,Antenna,Drain,Waste,Sewage,WasteWater,Water,Heating,DistrictHeating,Electricity,Tele,TeleExtended,Gas,Oil,Goods,Sprinkler,Assorted,'" />
  <xsl:variable name="UtilityStatType_listID" select="'urn:oioubl:codelist:utilitystatementtypecode-1.0'" />
  <xsl:variable name="UtilityStatType_agencyID" select="'320'" />
  <xsl:variable name="UtilityPrivacyCode" select="',CompanyLevel,UserLevel,NotRelevant,'" />
  <xsl:variable name="UtilityPrivacyCode_listID" select="'urn:oioubl:codelist:privacycode-1.0'" />
  <xsl:variable name="UtilityPrivacyCode_agencyID" select="'320'" />
  <xsl:variable name="UtilityTeleCatCode" select="',Subscription,OneTime,Consumption,Service900,SpecialServices,Assorted,'" />
  <xsl:variable name="UtilityTeleCatCode_listID" select="'urn:oioubl:codelist:telecategorycode-1.0'" />
  <xsl:variable name="UtilityTeleCatCode_agencyID" select="'320'" />
  <xsl:variable name="UtilityTeleSupTypeCode" select="',Tele,Internet,Television,Assorted,'" />
  <xsl:variable name="UtilityTeleSupTypeCode_listID" select="'urn:oioubl:codelist:telecommunicationssupplytypecode-1.0'" />
  <xsl:variable name="UtilityTeleSupTypeCode_agencyID" select="'320'" />
  <xsl:variable name="UtilityTeleCallCode" select="',CallAttempt,Freephone,SwitchedCall,ZoneCall,ServiceNumber,Services,Streaming,Roaming,TastSelv,Data,Mobile,WiredPhone,FAX,SMS,MMS,WAP,GPRS,Assorted,'" />
  <xsl:variable name="UtilityTeleCallCode_listID" select="'urn:oioubl:codelist:telecallcode-1.0'" />
  <xsl:variable name="UtilityTeleCallCode_agencyID" select="'320'" />
  <xsl:variable name="UtilityDutyCode" select="',CallAttempt,ConnectionFee,InternationalConnection,Freephone,ZoneCall,Roaming,Donation,Service900,SpecialServices,ServiceNumber,Services,TastSelv,Switched,Routed,ConsumptionFee,ConsumptionInternational,ConsumptionSpecialRate,Streaming,Charge,Discount,Assorted,'" />
  <xsl:variable name="UtilityDutyCode_listID" select="'urn:oioubl:codelist:dutycode-1.0'" />
  <xsl:variable name="UtilityDutyCode_agencyID" select="'320'" />
  <xsl:variable name="UtilitySpecTypeCode" select="',Onaccount,YearlyStatement,FinalSettlement,Statement,MonthlyStatement,QuarterlyStatement,SixMonthStatement,CurrentStatement,RelocationSettlement,ExtraordinaryStatement,Regulation,Cancellation,Assorted,'" />
  <xsl:variable name="UtilitySpecTypeCode_listID" select="'urn:oioubl:codelist:specificationtypecode-1.0'" />
  <xsl:variable name="UtilitySpecTypeCode_agencyID" select="'320'" />
  <xsl:variable name="UtilitySubIDTypeCode" select="',APL,DPA,DSH,DX,ERH,FKR,FLX,FRS,IP,ISP,IWA,KPM,KT1,KT2,KT3,MOB,NAV,PBS,SIK,SUS,TIP,TKA,TLF,VAG,VSS,GSM,CDA,PBX,ISP,ZZZ,'" />
  <xsl:variable name="UtilitySubIDTypeCode_listID" select="'urn:oioubl:codelist:subscriberidtypecode-1.0'" />
  <xsl:variable name="UtilitySubIDTypeCode_agencyID" select="'320'" />
  <xsl:variable name="UtilityMeterConCode" select="',Factor,'" />
  <xsl:variable name="UtilityMeterConCode_listID" select="'urn:oioubl:codelist:meterconstantcode-1.0'" />
  <xsl:variable name="UtilityMeterConCode_agencyID" select="'320'" />
  <xsl:variable name="UtilityReaMetCode" select="',Remote,ReadByInspector,Card,SMS,PDA,VoiceResponse,WEB,Estimated,EstimatedAutomatic,EstimatedOfficer,EstimatedAfterError,Reset,PieceCount,HourlyAmount,Manual,CustomerService,Calculated,Unknown,'" />
  <xsl:variable name="UtilityReaMetCode_listID" select="'urn:oioubl:codelist:meterreadingmethodcode-1.0'" />
  <xsl:variable name="UtilityReaMetCode_agencyID" select="'320'" />
  <xsl:variable name="UtilityMRTypeCode" select="',Electricity,Water,Heating,Gas,Oil,Sewage,WasteWater,RefuseDisposal,DistantCooling,Assorted,'" />
  <xsl:variable name="UtilityMRTypeCode_listID" select="'urn:oioubl:codelist:meterreadingtypecode-1.0'" />
  <xsl:variable name="UtilityMRTypeCode_agencyID" select="'320'" />
  <xsl:variable name="UtilityConTypeCode" select="',Subscription,Consumption,Service900,SpecialServices,Assorted,'" />
  <xsl:variable name="UtilityConTypeCode_listID" select="'urn:oioubl:codelist:consumptiontypecode-1.0'" />
  <xsl:variable name="UtilityConTypeCode_agencyID" select="'320'" />
  <xsl:variable name="UtilityCELCode" select="',A,B,C,D,E,F,G,'" />
  <xsl:variable name="UtilityCELCode_listID" select="'urn:oioubl:codelist:consumersenergylevelcode-1.0'" />
  <xsl:variable name="UtilityCELCode_agencyID" select="'320'" />
  <xsl:variable name="UtilityResTypeCode" select="',House,Apartment,IndustriProperty,Assorted,'" />
  <xsl:variable name="UtilityResTypeCode_listID" select="'urn:oioubl:codelist:residencetypecode-1.0'" />
  <xsl:variable name="UtilityResTypeCode_agencyID" select="'320'" />
  <xsl:variable name="UtilityHeaTypeCode" select="',Electricity,Gas,Oil,Coal,DistrictHeating,DistantCooling,SolarEnergy,WindEnergy,Wood,GeothermalHeat,Assorted,'" />
  <xsl:variable name="UtilityHeaTypeCode_listID" select="'urn:oioubl:codelist:heatingtypecode-1.0'" />
  <xsl:variable name="UtilityHeaTypeCode_agencyID" select="'320'" />
  <xsl:variable name="UtilityCorTypeCode" select="',HeatingCorrection,GasCorrection,OtherCorrection,'" />
  <xsl:variable name="UtilityCorTypeCode_listID" select="'urn:oioubl:codelist:correctiontypecode-1.0'" />
  <xsl:variable name="UtilityCorTypeCode_agencyID" select="'320'" />
  <xsl:variable name="UtilityCCTypeCode" select="',SubcriptionType1,SubcriptionType2,SubcriptionType3,ShortTermSubscription,ServiceSubscription,24HourServiceType1,24HourServiceType2,BasicService,3HourService,DeliveryService,CallInServiceType1,CallInServiceType2,RentalType1,RentalType2,Leasing,TeleTime,Attempt,Discount,EmployeeInternet,SalesSector,Sales,Administration,ShopService,Assorted,'" />
  <xsl:variable name="UtilityCCTypeCode_listID" select="'urn:oioubl:codelist:currentchargetypecode-1.0'" />
  <xsl:variable name="UtilityCCTypeCode_agencyID" select="'320'" />
  <xsl:variable name="UtilityOTCTypeCode" select="',InstallationCharge,ReInstallationCharge,Opening,ReOpening,Assumption,Installation,Connection,Change,NumberChange,Conversion,BuyBack,Reception,Relocation,Upgrade,Repair,Debugging,Compensation,MinConsumption,Charge,Discount,ServiceInformation,SpecialService,Blocking,Termination,Sealing,GoodsPayment,Assorted,'" />
  <xsl:variable name="UtilityOTCTypeCode_listID" select="'urn:oioubl:codelist:onetimechargetypecode-1.0'" />
  <xsl:variable name="UtilityOTCTypeCode_agencyID" select="'320'" />
  <xsl:variable name="Delivery_1" select="',EXW,FCA,FAS,FOB,CFR,CIF,CPT,CIP,DAF,DES,DEQ,DDU,DDP,'" />
  <xsl:variable name="Delivery_1_schemeID" select="'INCOTERMS 2000'" />
  <xsl:variable name="Delivery_1_agencyID" select="'NES'" />
  <xsl:variable name="Delivery_2" select="',001 EXW,002 FCA,003 FAS,004 FOB,005 FCA,006 CPT,007 CIP,008 CFR,009 CIF,010 CPT,011 CIP,012 CPT,013 CIP,014 CPT,015 CIP,016 DES,017 DRQ,018 DAF,019 DDU,021 DDP,022 DDU,023 DDP,'" />
  <xsl:variable name="Delivery_2_schemeID" select="'COMBITERMS 2000'" />
  <xsl:variable name="Delivery_2_agencyID" select="'NES'" />
  <xsl:variable name="Dimension" select="',A,AAA,AAB,AAC,AAD,AAE,AAF,AAJ,AAK,AAL,AAM,AAN,AAO,AAP,AAQ,AAR,AAS,AAT,AAU,AAV,AAW,AAX,AAY,AAZ,ABA,ABB,ABC,ABD,ABE,ABJ,ABS,ABX,ABY,ABZ,ACA,ACE,ACG,ACN,ACP,ACS,ACV,ACW,ACX,ADR,ADS,ADT,ADU,ADV,ADW,ADX,ADY,ADZ,AEA,AEB,AEC,AED,AEE,AEF,AEG,AEH,AEI,AEJ,AEK,AEM,AEN,AEO,AEP,AEQ,AER,AET,AEU,AEV,AEW,AEX,AEY,AEZ,AF,AFA,AFB,AFC,AFD,AFE,AFF,AFG,AFH,AFI,AFJ,AFK,B,BL,BMY,BMZ,BNA,BNB,BNC,BND,BNE,BNF,BNG,BNH,BNI,BNJ,BNK,BNL,BNM,BNN,BNO,BNP,BNQ,BNR,BNS,BNT,BR,BRA,BRE,BS,BSW,BW,CHN,CM,CT,CV,CZ,D,DI,DL,DN,DP,DR,DS,DW,E,EA,F,FI,FL,FN,FV,G,GG,GW,HF,HM,HT,IB,ID,L,LM,LN,LND,M,MO,MW,N,OD,PRS,PTN,RA,RF,RJ,RMW,RP,RUN,RY,SQ,T,TC,TH,TN,TT,U,VH,VW,WA,WD,WM,WT,WU,XH,XQ,XZ,YS,ZAL,ZAS,ZB,ZBI,ZC,ZCA,ZCB,ZCE,ZCL,ZCO,ZCR,ZCU,ZFE,ZFS,ZGE,ZH,ZK,ZMG,ZMN,ZMO,ZN,ZNA,ZNB,ZNI,ZO,ZP,ZPB,ZS,ZSB,ZSE,ZSI,ZSL,ZSN,ZTA,ZTE,ZTI,ZV,ZW,ZWA,ZZN,ZZR,ZZZ,'" />
  <xsl:variable name="Dimension_schemeID" select="'UN/ECE 6313'" />
  <xsl:variable name="Dimension_agencyID" select="'6'" />
  <xsl:variable name="BIC" select="'rule'" />
  <xsl:variable name="BIC_schemeID" select="'BIC'" />
  <xsl:variable name="BIC_agencyID" select="'17'" />
  <xsl:variable name="IBAN" select="'rule'" />
  <xsl:variable name="IBAN_schemeID" select="'IBAN'" />
  <xsl:variable name="IBAN_agencyID" select="'17'" />
  <xsl:variable name="LocID" select="'rule'" />
  <xsl:variable name="LocID_schemeID" select="'UN/ECE rec 16'" />
  <xsl:variable name="LocID_agencyID" select="'6'" />
  <xsl:variable name="PaymentID" select="',01,04,15,71,73,75,'" />
  <xsl:variable name="PaymentID_schemeID" select="'urn:oioubl:id:paymentid-1.1'" />
  <xsl:variable name="PaymentID_agencyID" select="'320'" />
  <xsl:variable name="Profile1" select="',NONE,Procurement-BilSim-1.0,Procurement-BilSimR-1.0,Procurement-PayBas-1.0,Procurement-PayBasR-1.0,Procurement-OrdSim-BilSim-1.0,Procurement-OrdSimR-BilSim-1.0,Procurement-OrdSim-BilSimR-1.0,Procurement-OrdSimR-BilSimR-1.0,Procurement-OrdAdv-BilSim-1.0,Procurement-OrdAdv-BilSimR-1.0,Procurement-OrdAdvR-BilSim-1.0,Procurement-OrdAdvR-BilSimR-1.0,Procurement-OrdSel-BilSim-1.0,Procurement-OrdSel-BilSimR-1.0,Catalogue-CatBas-1.0,Catalogue-CatBasR-1.0,Catalogue-CatSim-1.0,Catalogue-CatSimR-1.0,Catalogue-CatExt-1.0,Catalogue-CatExtR-1.0,Catalogue-CatAdv-1.0,Catalogue-CatAdvR-1.0,urn:www.nesubl.eu:profiles:profile1:ver1.0,urn:www.nesubl.eu:profiles:profile2:ver1.0,urn:www.nesubl.eu:profiles:profile5:ver1.0,urn:www.nesubl.eu:profiles:profile7:ver1.0,urn:www.nesubl.eu:profiles:profile8:ver1.0,'" />
  <xsl:variable name="Profile1_schemeID" select="'urn:oioubl:id:profileid-1.1'" />
  <xsl:variable name="Profile1_agencyID" select="'320'" />
  <xsl:variable name="Profile2" select="',NONE,Procurement-BilSim-1.0,Procurement-BilSimR-1.0,Procurement-PayBas-1.0,Procurement-PayBasR-1.0,Procurement-OrdSim-BilSim-1.0,Procurement-OrdSimR-BilSim-1.0,Procurement-OrdSim-BilSimR-1.0,Procurement-OrdSimR-BilSimR-1.0,Procurement-OrdAdv-BilSim-1.0,Procurement-OrdAdv-BilSimR-1.0,Procurement-OrdAdvR-BilSim-1.0,Procurement-OrdAdvR-BilSimR-1.0,Procurement-OrdSel-BilSim-1.0,Procurement-OrdSel-BilSimR-1.0,Catalogue-CatBas-1.0,Catalogue-CatBasR-1.0,Catalogue-CatSim-1.0,Catalogue-CatSimR-1.0,Catalogue-CatExt-1.0,Catalogue-CatExtR-1.0,Catalogue-CatAdv-1.0,Catalogue-CatAdvR-1.0,urn:www.nesubl.eu:profiles:profile1:ver1.0,urn:www.nesubl.eu:profiles:profile2:ver1.0,urn:www.nesubl.eu:profiles:profile5:ver1.0,urn:www.nesubl.eu:profiles:profile7:ver1.0,urn:www.nesubl.eu:profiles:profile8:ver1.0,urn:www.nesubl.eu:profiles:profile1:ver2.0,urn:www.nesubl.eu:profiles:profile2:ver2.0,urn:www.nesubl.eu:profiles:profile5:ver2.0,urn:www.nesubl.eu:profiles:profile7:ver2.0,urn:www.nesubl.eu:profiles:profile8:ver2.0,'" />
  <xsl:variable name="Profile2_schemeID" select="'urn:oioubl:id:profileid-1.2'" />
  <xsl:variable name="Profile3" select="',NONE,Procurement-BilSim-1.0,Procurement-BilSimR-1.0,Procurement-PayBas-1.0,Procurement-PayBasR-1.0,Procurement-OrdSim-BilSim-1.0,Procurement-OrdSimR-BilSim-1.0,Procurement-OrdSim-BilSimR-1.0,Procurement-OrdSimR-BilSimR-1.0,Procurement-OrdAdv-BilSim-1.0,Procurement-OrdAdv-BilSimR-1.0,Procurement-OrdAdvR-BilSim-1.0,Procurement-OrdAdvR-BilSimR-1.0,Procurement-OrdSel-BilSim-1.0,Procurement-OrdSel-BilSimR-1.0,Catalogue-CatBas-1.0,Catalogue-CatBasR-1.0,Catalogue-CatSim-1.0,Catalogue-CatSimR-1.0,Catalogue-CatExt-1.0,Catalogue-CatExtR-1.0,Catalogue-CatAdv-1.0,Catalogue-CatAdvR-1.0,urn:www.nesubl.eu:profiles:profile1:ver1.0,urn:www.nesubl.eu:profiles:profile2:ver1.0,urn:www.nesubl.eu:profiles:profile5:ver1.0,urn:www.nesubl.eu:profiles:profile7:ver1.0,urn:www.nesubl.eu:profiles:profile8:ver1.0,urn:www.nesubl.eu:profiles:profile1:ver2.0,urn:www.nesubl.eu:profiles:profile2:ver2.0,urn:www.nesubl.eu:profiles:profile5:ver2.0,urn:www.nesubl.eu:profiles:profile7:ver2.0,urn:www.nesubl.eu:profiles:profile8:ver2.0,Reference-Utility-1.0,Reference-UtilityR-1.0,'" />
  <xsl:variable name="Profile3_schemeID" select="'urn:oioubl:id:profileid-1.3'" />
  <xsl:variable name="Profile4" select="',NONE,Procurement-BilSim-1.0,Procurement-BilSimR-1.0,Procurement-PayBas-1.0,Procurement-PayBasR-1.0,Procurement-OrdSim-1.0,Procurement-OrdSimR-1.0,Procurement-OrdSim-BilSim-1.0,Procurement-OrdSimR-BilSim-1.0,Procurement-OrdSim-BilSimR-1.0,Procurement-OrdSimR-BilSimR-1.0,Procurement-OrdAdv-BilSim-1.0,Procurement-OrdAdv-BilSimR-1.0,Procurement-OrdAdvR-BilSim-1.0,Procurement-OrdAdvR-BilSimR-1.0,Procurement-OrdSel-BilSim-1.0,Procurement-OrdSel-BilSimR-1.0,Catalogue-CatBas-1.0,Catalogue-CatBasR-1.0,Catalogue-CatSim-1.0,Catalogue-CatSimR-1.0,Catalogue-CatExt-1.0,Catalogue-CatExtR-1.0,Catalogue-CatAdv-1.0,Catalogue-CatAdvR-1.0,urn:www.nesubl.eu:profiles:profile1:ver1.0,urn:www.nesubl.eu:profiles:profile2:ver1.0,urn:www.nesubl.eu:profiles:profile5:ver1.0,urn:www.nesubl.eu:profiles:profile7:ver1.0,urn:www.nesubl.eu:profiles:profile8:ver1.0,urn:www.nesubl.eu:profiles:profile1:ver2.0,urn:www.nesubl.eu:profiles:profile2:ver2.0,urn:www.nesubl.eu:profiles:profile3:ver2.0,urn:www.nesubl.eu:profiles:profile5:ver2.0,urn:www.nesubl.eu:profiles:profile7:ver2.0,urn:www.nesubl.eu:profiles:profile8:ver2.0,Reference-Utility-1.0,Reference-UtilityR-1.0,urn:www.cenbii.eu:profile:bii30:ver2.0,Procurement-TecRes-1.0,Catalogue-CatPriUpd-1.0,Catalogue-CatPriUpdR-1.0,'" />
  <xsl:variable name="Profile4_schemeID" select="'urn:oioubl:id:profileid-1.4'" />
  <xsl:variable name="Profile5" select="',NONE,Procurement-BilSim-1.0,Procurement-BilSimR-1.0,Procurement-PayBas-1.0,Procurement-PayBasR-1.0,Procurement-OrdSim-1.0,Procurement-OrdSimR-1.0,Procurement-OrdSim-BilSim-1.0,Procurement-OrdSimR-BilSim-1.0,Procurement-OrdSim-BilSimR-1.0,Procurement-OrdSimR-BilSimR-1.0,Procurement-OrdAdv-BilSim-1.0,Procurement-OrdAdv-BilSimR-1.0,Procurement-OrdAdvR-BilSim-1.0,Procurement-OrdAdvR-BilSimR-1.0,Procurement-OrdSel-BilSim-1.0,Procurement-OrdSel-BilSimR-1.0,Catalogue-CatBas-1.0,Catalogue-CatBasR-1.0,Catalogue-CatSim-1.0,Catalogue-CatSimR-1.0,Catalogue-CatExt-1.0,Catalogue-CatExtR-1.0,Catalogue-CatAdv-1.0,Catalogue-CatAdvR-1.0,urn:www.nesubl.eu:profiles:profile1:ver1.0,urn:www.nesubl.eu:profiles:profile2:ver1.0,urn:www.nesubl.eu:profiles:profile5:ver1.0,urn:www.nesubl.eu:profiles:profile7:ver1.0,urn:www.nesubl.eu:profiles:profile8:ver1.0,urn:www.nesubl.eu:profiles:profile1:ver2.0,urn:www.nesubl.eu:profiles:profile2:ver2.0,urn:www.nesubl.eu:profiles:profile3:ver2.0,urn:www.nesubl.eu:profiles:profile5:ver2.0,urn:www.nesubl.eu:profiles:profile7:ver2.0,urn:www.nesubl.eu:profiles:profile8:ver2.0,Reference-Utility-1.0,Reference-UtilityR-1.0,urn:www.cenbii.eu:profile:bii30:ver2.0,Procurement-TecRes-1.0,Catalogue-CatPriUpd-1.0,Catalogue-CatPriUpdR-1.0,Procurement-OrdRes-1.0,'" />
  <xsl:variable name="Profile5_schemeID" select="'urn:oioubl:id:profileid-1.5'" />
  <xsl:variable name="Profile6" select="',NONE,Procurement-BilSim-1.0,Procurement-BilSimR-1.0,Procurement-PayBas-1.0,Procurement-PayBasR-1.0,Procurement-OrdSim-1.0,Procurement-OrdSimR-1.0,Procurement-OrdSim-BilSim-1.0,Procurement-OrdSimR-BilSim-1.0,Procurement-OrdSim-BilSimR-1.0,Procurement-OrdSimR-BilSimR-1.0,Procurement-OrdAdv-BilSim-1.0,Procurement-OrdAdv-BilSimR-1.0,Procurement-OrdAdvR-BilSim-1.0,Procurement-OrdAdvR-BilSimR-1.0,Procurement-OrdSel-BilSim-1.0,Procurement-OrdSel-BilSimR-1.0,Catalogue-CatBas-1.0,Catalogue-CatBasR-1.0,Catalogue-CatSim-1.0,Catalogue-CatSimR-1.0,Catalogue-CatExt-1.0,Catalogue-CatExtR-1.0,Catalogue-CatAdv-1.0,Catalogue-CatAdvR-1.0,urn:www.nesubl.eu:profiles:profile1:ver1.0,urn:www.nesubl.eu:profiles:profile2:ver1.0,urn:www.nesubl.eu:profiles:profile5:ver1.0,urn:www.nesubl.eu:profiles:profile7:ver1.0,urn:www.nesubl.eu:profiles:profile8:ver1.0,urn:www.nesubl.eu:profiles:profile1:ver2.0,urn:www.nesubl.eu:profiles:profile2:ver2.0,urn:www.nesubl.eu:profiles:profile3:ver2.0,urn:www.nesubl.eu:profiles:profile5:ver2.0,urn:www.nesubl.eu:profiles:profile7:ver2.0,urn:www.nesubl.eu:profiles:profile8:ver2.0,Reference-Utility-1.0,Reference-UtilityR-1.0,urn:www.cenbii.eu:profile:bii30:ver2.0,Procurement-TecRes-1.0,Catalogue-CatPriUpd-1.0,Catalogue-CatPriUpdR-1.0,Procurement-OrdRes-1.0,Procurement-BilSimReminderOnly-1.0,'" />
  <xsl:variable name="Profile6_schemeID" select="'urn:oioubl:id:profileid-1.6'" />
  <xsl:variable name="IbanOnly" select="',AT,BE,CY,EE,FI,FR,DE,GR,IE,IT,LV,LT,LU,MT,NL,PT,SK,SI,ES,BG,HR,CZ,DK,HU,PL,RO,SE,GB,IS,LI,NO,MC,SM,CH,'" />
  <xsl:variable name="TaxCategory1" select="',ZeroRated,StandardRated,ReverseCharge,Excise,3010,3020,3021,3022,3023,3024,3025,3030,3040,3041,3048,3049,3050,3051,3052,3053,3054,3055,3056,3057,3058,3059,3060,3061,3062,3063,3064,3065,3066,3067,3068,3070,3071,3072,3073,3075,3080,3081,3082,3083,3084,3085,3086,3090,3091,3092,3093,3094,3095,3096,3100,3101,3102,3120,3121,3122,3123,3130,3140,3141,3160,3161,3162,3163,3170,3171,3240,3241,3242,3245,3246,3247,3250,3251,3260,3271,3272,3273,3276,3277,3280,3281,3282,3283,3290,3291,3292,3293,3294,3295,3296,3297,3300,3301,3302,3303,3304,3305,3310,3311,3320,3321,3330,3331,3340,3341,3350,3351,3360,3370,3380,3400,3403,3404,3405,3406,3410,3420,3430,3440,3441,3451,3452,3453,3500,3501,3502,3503,3600,3620,3621,3622,3623,3624,3630,3631,3632,3633,3634,3635,3636,3637,3638,3640,3641,3645,3650,3660,3661,3670,3671,'" />
  <xsl:variable name="TaxCategory1_schemeID" select="'urn:oioubl:id:taxcategoryid-1.1'" />
  <xsl:variable name="TaxCategory1_agencyID" select="'320'" />
  <xsl:variable name="TaxCategory2" select="',ZeroRated,StandardRated,ReverseCharge,Excise,3010,3020,3021,3022,3023,3024,3025,3030,3040,3041,3048,3049,3050,3051,3052,3053,3054,3055,3056,3057,3058,3059,3060,3061,3062,3063,3064,3065,3066,3067,3068,3070,3071,3072,3073,3075,3077,3080,3081,3082,3083,3084,3085,3086,3090,3091,3092,3093,3094,3095,3096,3100,3101,3102,3104,3120,3121,3122,3123,3130,3140,3141,3160,3161,3162,3163,3170,3171,3240,3241,3242,3245,3246,3247,3250,3251,3260,3271,3272,3273,3276,3277,3280,3281,3282,3283,3290,3291,3292,3293,3294,3295,3296,3297,3300,3301,3302,3303,3304,3305,3310,3311,3320,3321,3330,3331,3340,3341,3350,3351,3360,3370,3380,3400,3403,3404,3405,3406,3410,3420,3430,3440,3441,3451,3452,3453,3500,3501,3502,3503,3600,3620,3621,3622,3623,3624,3630,3631,3632,3633,3634,3635,3636,3637,3638,3640,3641,3645,3650,3660,3661,3670,3671,310301,310302,310303,310304,310305,310306,310307,'" />
  <xsl:variable name="TaxCategory2_schemeID" select="'urn:oioubl:id:taxcategoryid-1.2'" />
  <xsl:variable name="TaxCategory2_agencyID" select="'320'" />
  <xsl:variable name="TaxCategory3" select="',ZeroRated,StandardRated,ReverseCharge,Excise,3010,3020,3021,3022,3023,3024,3025,3030,3031,3032,3033,3034,3040,3041,3048,3049,3050,3051,3052,3053,3054,3055,3056,3057,3058,3059,3060,3061,3062,3063,3064,3065,3066,3067,3068,3070,3071,3072,3073,3075,3077,3080,3081,3082,3083,3084,3085,3086,3090,3091,3092,3093,3094,3095,3096,3100,3101,3102,3103,3104,3120,3121,3122,3123,3130,3140,3141,3160,3161,3162,3163,3170,3171,3240,3241,3242,3245,3246,3247,3250,3251,3260,3271,3272,3273,3276,3277,3280,3281,3282,3283,3290,3291,3292,3293,3294,3295,3296,3297,3300,3301,3302,3303,3304,3305,3310,3311,3320,3321,3330,3331,3340,3341,3350,3351,3360,3370,3380,3400,3403,3404,3405,3406,3410,3420,3430,3440,3441,3451,3452,3453,3500,3501,3502,3503,3600,3620,3621,3622,3623,3624,3630,3631,3632,3633,3634,3635,3636,3637,3638,3639,3640,3641,3645,3650,3660,3661,310301,310302,310303,310304,310305,310306,310307,'" />
  <xsl:variable name="TaxCategory3_schemeID" select="'urn:oioubl:id:taxcategoryid-1.3'" />
  <xsl:variable name="TaxCategory3_agencyID" select="'320'" />
  <xsl:variable name="TaxScheme" select="',9,10,11,16,17,18,19,21,24,25,27,28,30,31,32,33,39,40,41,53,54,56,57,61,62,63,69,70,71,72,75,76,77,79,85,86,87,91,94,95,97,98,99,100,108,109,110,111,127,128,130,133,134,135,136,137,138,139,140,142,146,151,152,VAT,0,'" />
  <xsl:variable name="TaxScheme_schemeID" select="'urn:oioubl:id:taxschemeid-1.1'" />
  <xsl:variable name="TaxScheme_agencyID" select="'320'" />
  <xsl:variable name="TaxScheme2" select="',9,10,11,16,17,18,19,21,21a,21b,21c,21d,21e,21f,24,25,27,28,30,31,32,33,39,40,41,53,54,56,57,61,61a,62,63,69,70,71,72,75,76,77,79,85,86,87,91,94,94a,95,97,98,99,99a,100,108,109,110,110a,110b,110c,111,112,112a,112b,112c,112d,112e,112f,127,127a,127b,127c,128,130,133,134,135,136,137,138,139,140,142,146,151,152,VAT,0,'" />
  <xsl:variable name="TaxScheme2_schemeID" select="'urn:oioubl:id:taxschemeid-1.2'" />
  <xsl:variable name="TaxScheme2_agencyID" select="'320'" />
  <xsl:variable name="TaxScheme4" select="',9,10,11,16,17,18,19,21,21a,21b,21c,21d,21e,21f,24,25,27,28,30,31,32,33,39,40,41,53,54,56,57,61,61a,62,63,68,69,70,71,72,75,76,77,79,85,86,87,91,94,95,97,98,99,99a,100,108,109,110,110a,110b,110c,111,112,112a,112b,112c,112d,112e,112f,127,127a,127b,127c,128,130,133,134,135,136,137,138,139,140,142,146,151,152,171,VAT,0,'" />
  <xsl:variable name="TaxScheme4_schemeID" select="'urn:oioubl:id:taxschemeid-1.4'" />
  <xsl:variable name="TaxScheme4_agencyID" select="'320'" />
  <xsl:variable name="TaxScheme5" select="',9,10,16,17,18,19,21,21a,21b,21c,21d,21e,21f,24,25,27,30,31,32,33,39,40,54,56,57,61,61a,63,68,69,70,71,72,75,76,77,79,85,87,91,94,95,97,98,100,108,109,110,110a,110b,110c,111,127,127a,127b,127c,128,130,133,134,135,136,137,138,139,142,146,151,152,156,160,161,162,163,164,167,168,184,185,186,VAT,0,'" />
  <xsl:variable name="TaxScheme5_schemeID" select="'urn:oioubl:id:taxschemeid-1.5'" />
  <xsl:variable name="TaxScheme5_agencyID" select="'320'" />
  <xsl:variable name="EndpointID_schemeID" select="',GLN,DUNS,DK:P,DK:CVR,DK:CPR,DK:SE,DK:VANS,FR:SIRET,SE:ORGNR,SE:VAT,FI:OVT,FI:ORGNR,FI:VAT,IT:FTI,IT:SIA,IT:SECETI,IT:VAT,IT:CF,NO:ORGNR,NO:VAT,HU:VAT,EU:VAT,EU:REID,AT:VAT,AT:GOV,AT:CID,IS:KT,IBAN,AT:KUR,ES:VAT,IT:IPA,AD:VAT,AL:VAT,BA:VAT,BE:VAT,BG:VAT,CH:VAT,CY:VAT,CZ:VAT,DE:VAT,EE:VAT,GB:VAT,GR:VAT,HR:VAT,IE:VAT,LI:VAT,LT:VAT,LU:VAT,LV:VAT,MC:VAT,ME:VAT,MK:VAT,MT:VAT,NL:VAT,PL:VAT,PT:VAT,RO:VAT,RS:VAT,SI:VAT,SK:VAT,SM:VAT,TR:VAT,VA:VAT,'" />
  <xsl:variable name="PartyID_schemeID" select="',GLN,DUNS,DK:P,DK:CVR,DK:CPR,DK:SE,FR:SIRET,ZZZ,DK:TELEFON,FI:ORGNR,IS:VSKNR,NO:EFO,NO:NOBB,NO:NODI,NO:ORGNR,NO:VAT,SE:VAT,SE:ORGNR,FI:OVT,FI:ORGNR,FI:VAT,IT:FTI,IT:SIA,IT:SECETI,IT:VAT,IT:CF,HU:VAT,EU:VAT,EU:REID,AT:VAT,AT:GOV,AT:CID,IS:KT,IBAN,AT:KUR,ES:VAT,IT:IPA,AD:VAT,AL:VAT,BA:VAT,BE:VAT,BG:VAT,CH:VAT,CY:VAT,CZ:VAT,DE:VAT,EE:VAT,GB:VAT,GR:VAT,HR:VAT,IE:VAT,LI:VAT,LT:VAT,LU:VAT,LV:VAT,MC:VAT,ME:VAT,MK:VAT,MT:VAT,NL:VAT,PL:VAT,PT:VAT,RO:VAT,RS:VAT,SI:VAT,SK:VAT,SM:VAT,TR:VAT,VA:VAT,SEPA,'" />
  <xsl:variable name="PartyLegalID" select="',DK:CVR,DK:CPR,ZZZ,'" />
  <xsl:variable name="PartyTaxID" select="',DK:SE,ZZZ,'" />
  <xsl:variable name="UtilityCPointID" select="',GSRN,ZZZ,'" />
  <xsl:variable name="Quantity_unitCode" select="',04,05,08,10,11,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,40,41,43,44,45,46,47,48,53,54,56,57,58,59,60,61,62,63,64,66,69,71,72,73,74,76,77,78,80,81,84,85,87,89,90,91,92,93,94,95,96,97,98,1A,1B,1C,1D,1E,1F,1G,1H,1I,1J,1K,1L,1M,1X,2A,2B,2C,2I,2J,2K,2L,2M,2N,2P,2Q,2R,2U,2V,2W,2X,2Y,2Z,3B,3C,3E,3G,3H,3I,4A,4B,4C,4E,4G,4H,4K,4L,4M,4N,4O,4P,4Q,4R,4T,4U,4W,4X,5A,5B,5C,5E,5F,5G,5H,5I,5J,5K,5P,5Q,A1,A10,A11,A12,A13,A14,A15,A16,A17,A18,A19,A2,A20,A21,A22,A23,A24,A25,A26,A27,A28,A29,A3,A30,A31,A32,A33,A34,A35,A36,A37,A38,A39,A4,A40,A41,A42,A43,A44,A45,A47,A48,A49,A5,A50,A51,A52,A53,A54,A55,A56,A57,A58,A6,A60,A61,A62,A63,A64,A65,A66,A67,A68,A69,A7,A70,A71,A73,A74,A75,A76,A77,A78,A79,A8,A80,A81,A82,A83,A84,A85,A86,A87,A88,A89,A9,A90,A91,A93,A94,A95,A96,A97,A98,AA,AB,ACR,AD,AE,AH,AI,AJ,AK,AL,AM,AMH,AMP,ANN,AP,APZ,AQ,AR,ARE,AS,ASM,ASU,ATM,ATT,AV,AW,AY,AZ,B0,B1,B11,B12,B13,B14,B15,B16,B18,B2,B20,B21,B22,B23,B24,B25,B26,B27,B28,B29,B3,B31,B32,B33,B34,B35,B36,B37,B38,B39,B4,B40,B41,B42,B43,B44,B45,B46,B47,B48,B49,B5,B50,B51,B52,B53,B54,B55,B56,B57,B58,B59,B6,B60,B61,B62,B63,B64,B65,B66,B67,B69,B7,B70,B71,B72,B73,B74,B75,B76,B77,B78,B79,B8,B81,B83,B84,B85,B86,B87,B88,B89,B9,B90,B91,B92,B93,B94,B95,B96,B97,B98,B99,BAR,BB,BD,BE,BFT,BG,BH,BHP,BIL,BJ,BK,BL,BLD,BLL,BO,BP,BQL,BR,BT,BTU,BUA,BUI,BW,BX,BZ,C0,C1,C10,C11,C12,C13,C14,C15,C16,C17,C18,C19,C2,C20,C22,C23,C24,C25,C26,C27,C28,C29,C3,C30,C31,C32,C33,C34,C35,C36,C38,C39,C4,C40,C41,C42,C43,C44,C45,C46,C47,C48,C49,C5,C50,C51,C52,C53,C54,C55,C56,C57,C58,C59,C6,C60,C61,C62,C63,C64,C65,C66,C67,C68,C69,C7,C70,C71,C72,C73,C75,C76,C77,C78,C8,C80,C81,C82,C83,C84,C85,C86,C87,C88,C89,C9,C90,C91,C92,C93,C94,C95,C96,C97,C98,C99,CA,CCT,CDL,CEL,CEN,CG,CGM,CH,CJ,CK,CKG,CL,CLF,CLT,CMK,CMQ,CMT,CNP,CNT,CO,COU,CQ,CR,CS,CT,CTM,CU,CUR,CV,CWA,CWI,CY,CZ,D1,D10,D12,D13,D14,D15,D16,D17,D18,D19,D2,D20,D21,D22,D23,D24,D25,D26,D27,D28,D29,D30,D31,D32,D33,D34,D35,D37,D38,D39,D40,D41,D42,D43,D44,D45,D46,D47,D48,D49,D5,D50,D51,D52,D53,D54,D55,D56,D57,D58,D59,D6,D60,D61,D62,D63,D64,D65,D66,D67,D69,D7,D70,D71,D72,D73,D74,D75,D76,D77,D79,D8,D80,D81,D82,D83,D85,D86,D87,D88,D89,D9,D90,D91,D92,D93,D94,D95,D96,D97,D98,D99,DAA,DAD,DAY,DB,DC,DD,DE,DEC,DG,DI,DJ,DLT,DMK,DMQ,DMT,DN,DPC,DPR,DPT,DQ,DR,DRA,DRI,DRL,DRM,DS,DT,DTN,DU,DWT,DX,DY,DZN,DZP,E2,E3,E4,E5,EA,EB,EC,EP,EQ,EV,F1,F9,FAH,FAR,FB,FC,FD,FE,FF,FG,FH,FL,FM,FOT,FP,FR,FS,FTK,FTQ,G2,G3,G7,GB,GBQ,GC,GD,GE,GF,GFI,GGR,GH,GIA,GII,GJ,GK,GL,GLD,GLI,GLL,GM,GN,GO,GP,GQ,GRM,GRN,GRO,GRT,GT,GV,GW,GWH,GY,GZ,H1,H2,HA,HAR,HBA,HBX,HC,HD,HE,HF,HGM,HH,HI,HIU,HJ,HK,HL,HLT,HM,HMQ,HMT,HN,HO,HP,HPA,HS,HT,HTZ,HUR,HY,IA,IC,IE,IF,II,IL,IM,INH,INK,INQ,IP,IT,IU,IV,J2,JB,JE,JG,JK,JM,JO,JOU,JR,K1,K2,K3,K5,K6,KA,KB,KBA,KD,KEL,KF,KG,KGM,KGS,KHZ,KI,KJ,KJO,KL,KMH,KMK,KMQ,KNI,KNS,KNT,KO,KPA,KPH,KPO,KPP,KR,KS,KSD,KSH,KT,KTM,KTN,KUR,KVA,KVR,KVT,KW,KWH,KWT,KX,L2,LA,LBR,LBT,LC,LD,LE,LEF,LF,LH,LI,LJ,LK,LM,LN,LO,LP,LPA,LR,LS,LTN,LTR,LUM,LUX,LX,LY,M0,M1,M4,M5,M7,M9,MA,MAL,MAM,MAW,MBE,MBF,MBR,MC,MCU,MD,MF,MGM,MHZ,MIK,MIL,MIN,MIO,MIU,MK,MLD,MLT,MMK,MMQ,MMT,MON,MPA,MQ,MQH,MQS,MSK,MT,MTK,MTQ,MTR,MTS,MV,MVA,MWH,N1,N2,N3,NA,NAR,NB,NBB,NC,NCL,ND,NE,NEW,NF,NG,NH,NI,NIU,NJ,NL,NMI,NMP,NN,NPL,NPR,NPT,NQ,NR,NRL,NT,NTT,NU,NV,NX,NY,OA,OHM,ON,ONZ,OP,OT,OZ,OZA,OZI,P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,PA,PAL,PB,PD,PE,PF,PG,PGL,PI,PK,PL,PM,PN,PO,PQ,PR,PS,PT,PTD,PTI,PTL,PU,PV,PW,PY,PZ,Q3,QA,QAN,QB,QD,QH,QK,QR,QT,QTD,QTI,QTL,QTR,R1,R4,R9,RA,RD,RG,RH,RK,RL,RM,RN,RO,RP,RPM,RPS,RS,RT,RU,S3,S4,S5,S6,S7,S8,SA,SAN,SCO,SCR,SD,SE,SEC,SET,SG,SHT,SIE,SK,SL,SMI,SN,SO,SP,SQ,SR,SS,SST,ST,STI,STN,SV,SW,SX,T0,T1,T3,T4,T5,T6,T7,T8,TA,TAH,TC,TD,TE,TF,TI,TJ,TK,TL,TN,TNE,TP,TPR,TQ,TQD,TR,TRL,TS,TSD,TSH,TT,TU,TV,TW,TY,U1,U2,UA,UB,UC,UD,UE,UF,UH,UM,VA,VI,VLT,VQ,VS,W2,W4,WA,WB,WCD,WE,WEB,WEE,WG,WH,WHR,WI,WM,WR,WSD,WTT,WW,X1,YDK,YDQ,YL,YRD,YT,Z1,Z2,Z3,Z4,Z5,Z6,Z8,ZP,ZZ,'" />
  <xsl:variable name="PersonalSecure" select="',1,2,'" />
  <xsl:variable name="PersonalSecure_schemeID" select="'urn:oioubl:id:personalsecure-1.0'" />
  <xsl:variable name="PersonalSecure_agencyID" select="'320'" />
  <xsl:variable name="Environment_Value" select="',100_PERCENT_CANADIAN_MILK,100_PERCENT_VEGANSKT,3PMSF,ACMI,ADCCPA,AFIA_PET_FOOD_FACILITY,AGENCE_BIO,AGRI_CONFIANCE,AGRI_NATURA,AGRICULTURE_BIOLOGIQUE,AHAM,AISE,AISE_2005,AISE_2010,AISE_2020_BRAND,AISE_2020_COMPANY,AKC_PEACH_KOSHER,ALENTEJO_SUSTAINABILITY_PROGRAMME,ALIMENTATION_DU_TOUT_PETIT,ALIMENTS_BIO_PREPARES_AU_QUEBEC,ALIMENTS_DU_QUEBEC,ALIMENTS_DU_QUEBEC_BIO,ALIMENTS_PREPARES_AU_QUEBEC,ALPINAVERA,ALUMINIUM_GESAMTVERBAND_DER_ALUMINIUMINDUSTRIE,AMA_GENUSSREGION,AMA_ORGANIC_SEAL,AMA_ORGANIC_SEAL_BLACK,AMA_SEAL_OF_APPROVAL,AMERICAN_DENTAL_ASSOCIATION,AMERICAN_HEART_ASSOCIATION_CERTIFIED,ANIMAL_WELFARE_APPROVED_GRASSFED,AOP,APPELLATION_ORIGINE_CONTROLEE,APPROVED_BY_ASTHMA_AND_ALLERGY_ASSOC,AQUA_GAP,AQUACULTURE_STEWARDSHIP_COUNCIL,ARGE_GENTECHNIK_FREI,ARGENCERT,ARLA_FARMER_OWNED,ASCO,ASMI,ASTHMA_AND_ALLERGY_FOUNDATION_OF_AMERICA,ATG,AUS_KAUP_ESTONIA,AUSTRALIAN_CERTIFIED_ORGANIC,AUSTRIA_BIO_GARANTIE,AUSTRIAN_ECO_LABEL,BCARA_ORGANIC,BDIH_LOGO,BEBAT,BEDRE_DYREVELFAERD_1HEART,BEDRE_DYREVELFAERD_2HEART,BEDRE_DYREVELFAERD_3HEART,BEE_FRIENDLY,BELGAQUA,BENOR,BERCHTESGADENER_LAND,BEST_AQUACULTURE_PRACTICES,BEST_AQUACULTURE_PRACTICES_2_STARS,BEST_AQUACULTURE_PRACTICES_3_STARS,BEST_AQUACULTURE_PRACTICES_4_STARS,BETER_LEVEN_1_STER,BETER_LEVEN_2_STER,BETER_LEVEN_3_STER,BETTER_BUSINESS_BUREAU_ACCREDITED,BETTER_COTTON_INITIATIVE,BEVEG,BEWUSST_TIROL,BEWUSTE_KEUZE,BIKO_TIROL,BIO_AUSTRIA_LABEL,BIO_BAYERN_WITH_CERTIFICATE_PROVENANCE,BIO_BAYERN_WITHOUT_CERTIFICATE_PROVENANCE,BIO_BUD_SEAL,BIO_BUD_SEAL_TRANSITION,BIO_CZECH_LABEL,BIO_FISCH,BIO_GOURMET_BUD,BIO_LABEL_BADEN_WURTTENBERG,BIO_LABEL_GERMAN,BIO_LABEL_HESSEN,BIO_PARTENAIRE,BIO_RING_ALLGAEU,BIO_SOLIDAIRE,BIO_SUISSE_BUD_SEAL,BIO_SUISSE_BUD_SEAL_TRANSITION,BIOCHECKED_NON_GLYPHOSATE_CERTIFIED,BIOCHECKED_NON_GMO_VERIFIED,BIODEGRADABLE,BIODEGRADABLE_PRODUCTS_INSTITUTE,BIODYNAMIC_CERTIFICATION,BIODYNAMISCH,BIOGARANTIE,BIOKREIS,BIOLAND,BIOLAND_ENNSTAL,BIOPARK,BIOS_KONTROLLE,BIRD_FRIENDLY_COFFEE_SMITHSONIAN_CERTIFICATION,BK_CHECK_VAAD_HAKASHRUS_OF_BUFFALO,BLEU_BLANC_COEUR,BLUE_ANGEL,BLUE_RIBBON_KOSHER,BLUESIGN,BODEGAS_ARGENTINA_SUSTAINABILITY_PROTOCOL,BONSUCRO,BORD_BIA_APPROVED,BORD_BIA_APPROVED_MEAT,BRA_MILJOVAL_LABEL_SWEDISH,BRC_GLOBAL_STANDARDS,BREATHEWAY,BRITISH_DENTAL_HEALTH,BRITISH_RETAIL_CONSORTIUM_CERTIFICATION,BSCI,BULLFROG,CA_BEEF,CA_BOTH_DOM_IMPORT,CA_BULK,CA_CANNED,CA_DISTILLED,CA_IMPORT,CA_INGREDIENT,CA_MADE,CA_MUSTARD_SEEDS,CA_OATS,CA_PREPARED,CA_PROCESSED,CA_PRODUCT,CA_PROUD,CA_REFINED,CA_ROASTED_BLENDED,CAC_ABSENCE_EGG_MILK,CAC_ABSENCE_EGG_MILK_PEANUTS,CAC_ABSENCE_OF_ALMOND,CAC_ABSENCE_OF_EGG,CAC_ABSENCE_OF_MILK,CAC_ABSENCE_OF_PEANUT,CAC_ABSENCE_PEANUT_ALMOND,CAFE_PRACTICES,CAN_BNQ_CERTIFIED,CANADA_GAP,CANADIAN_AGRICULTURAL_PRODUCTS,CANADIAN_ASSOCIATION_FIRE_CHIEFS_APPROVED,CANADIAN_CERTIFIED_COMPOSTABLE,CANADIAN_DERMATOLOGY_ASSOCIATION_SKIN_HEALTH,CANADIAN_DERMATOLOGY_ASSOCIATION_SUN_PROTECTION,CARBON_FOOTPRINT_STANDARD,CARBON_NEUTRAL,CARBON_NEUTRAL_NCOS_CERTIFIED,CARBON_NEUTRAL_PACKAGING,CARIBBEAN_KOSHER,CCA_GLUTEN_FREE,CCC,CCF_RABBIT,CCOF,CCSW,CEBEC,CEL,CELIAC_SPRUE_ASSOCIATION,CENTRAL_RABBINICAL_CONGRESS_KOSHER,CERTIFIE_TERROIR_CHARLEVOIX,CERTIFIED_ANGUS_BEEF,CERTIFIED_B_CORPORATION,CERTIFIED_CARBON_FREE,CERTIFIED_HUMANE_ORGANISATION,CERTIFIED_NATURALLY_GROWN,CERTIFIED_OE_100,CERTIFIED_ORGANIC_BAYSTATE_ORGANIC_CERTIFIERS,CERTIFIED_ORGANIC_BY_ORGANIC_CERTIFIERS,CERTIFIED_PALEO,CERTIFIED_PALEO_FRIENDLY,CERTIFIED_PLANT_BASED,CERTIFIED_SUSTAINABLE_WINE_CHILE,CERTIFIED_WBENC,CERTIFIED_WILDLIFE_FRIENDLY,CFG_PROCESSED_EGG,CFIA,CFIA_DAIRY,CFIA_FISH,CFIA_GRADE_A,CFIA_GRADE_C,CFIA_ORGANIC,CFIA_UTILITY_POULTRY_EGG,CHASSEURS_DE_FRANCE,CHEESE_WORLD_CHAMPION_CHEESE_CONTEST,CHES_K,CHICAGO_RABBINICAL_COUNCIL,CINCINNATI_KOSHER,CLARO_FAIR_TRADE,CLIMATE_NEUTRAL,CLIMATE_NEUTRAL_PARTNER,CNG,CO2_REDUCERET_EMBALLAGE,CO2LOGIC_CO2_NEUTRAL_CERTIFIED,COCOA_HORIZONS,COCOA_LIFE,COMPOSTABLE_DIN_CERTCO,COMTE_GREEN_BELL,CONFORMITE_EUROPEENNE,CONSUMER_CHOICE_AWARD,COR_DETROIT,COR_KOSHER,CORRUGATED_RECYCLES,COSMEBIO,COSMEBIO_COSMOS_NATURAL,COSMEBIO_COSMOS_ORGANIC,COTTON_MADE_IN_AFRICA,CPE_SCHARREL_EIEREN,CPE_VRIJE_UITLOOP_EIEREN,CRADLE_TO_CRADLE,CROSSED_GRAIN_SYMBOL,CROWN_CHK,CRUELTY_FREE_PETA,CSA_INTERNATIONAL,CSA_NCA_GLUTEN_FREE,CSI,CULINARIUM,CULTIVUP_EXIGENCE,CULTIVUP_RESPONSABLE,CZECH_FOOD,DALLAS_KOSHER,DANSK_IP_KVALITET,DANSK_MAELK,DEBIO,DELINAT,DEMETER_LABEL,DESIGN_FOR_THE_ENVIRONMENT,DESIGN_FROM_FINLAND,DIAMOND_K,DIAMOND_KA_KASHRUT_AUTHORITY_OF_AUSTRALIA_AND_NZ,DIRECT_TRADE,DK_ECO,DLG_AWARD,DLG_CERTIFIED_ALLERGEN_MANAGEMENT ,DNV_BUSINESS_ASSURANCE,DOLPHIN_SAFE,DONAU_SOYA_STANDARD,DRP,DUURZAAM_VARKENSVLEES,DVF_VEGAN,DVF_VEGETARIAN,DYRENES_BESKYTTELSE,DZG_GLUTEN_FREE,EARTHKOSHER_KOSHER,EARTHSURE,ECARF_SEAL,ECO_KREIS,ECO_LABEL_CZECH,ECO_LABEL_LADYBUG,ECO_LOGO,ECOCERT_CERTIFICATE,ECOCERT_COSMOS_NATURAL,ECOCERT_COSMOS_ORGANIC,ECOCERT_ORGANIC,ECOGARANTIE,ECOLAND,ECOLOGO_CERTIFIED,ECOLOGO_CERTIFIED_2,ECOVIN,ECZEMA_SOCIETY_OF_CANADA,EESTI_OKOMARK,EESTI_PARIM_TOIDUAINE,EKO,ENEC,ENERGY_LABEL_A,ENERGY_LABEL_A+,ENERGY_LABEL_A++,ENERGY_LABEL_A+++,ENERGY_LABEL_B,ENERGY_LABEL_C,ENERGY_LABEL_D,ENERGY_LABEL_E,ENERGY_LABEL_F,ENERGY_LABEL_G,ENERGY_STAR,ENTREPRISE_DU_PATRIMOINE_VIVANT,ENTWINE_AUSTRALIA,EPA_DFE,EPEAT_BRONZE,EPEAT_GOLD,EPEAT_SILVER,EQUAL_EXCHANGE_FAIRLY_TRADED,EQUALITAS_SUSTAINABLE_WINE,ERDE_SAAT,ERKEND_STREEK_PRODUCT,ETP,EU_ECO_LABEL,EU_ENERGY_LABEL,EU_ORGANIC_FARMING,EUROPE_SOYA_STANDARD,EUROPEAN_V_LABEL_VEGAN,EUROPEAN_V_LABEL_VEGETARIAN,EUROPEAN_VEGETARIAN_UNION,EWG_VERIFIED,FAIR_FLOWERS_FAIR_PLANTS,FAIR_FOOD_PROGRAM_LABEL,FAIR_FOR_LIFE,FAIR_N_GREEN,FAIR_TRADE_MARK,FAIR_TRADE_USA,FAIR_TRADE_USA,FAIR_TRADE_USA_INGREDIENTS,FAIR_TSA,FAIRTRADE_CASHEW_NUTS,FAIRTRADE_COCOA,FAIRTRADE_COCONUT,FAIRTRADE_COTTON,FAIRTRADE_DRIED_APRICOTS,FAIRTRADE_GREEN_TEA,FAIRTRADE_HONEY,FAIRTRADE_LIME_JUICE,FAIRTRADE_MANGO_JUICE,FAIRTRADE_OLIVE_OIL,FAIRTRADE_PEPPER,FAIRTRADE_QUINOA,FAIRTRADE_RICE,FAIRTRADE_ROSES,FAIRTRADE_SUGAR,FAIRTRADE_TEA,FAIRTRADE_VANILLA,FALKEN,FCC,FEDERALLY_REGISTERED_INSPECTED_CANADA,FIDELIO,FINNISH_HEART_SYMBOL,FISH_WISE_CERTIFCATION,FLAMME_VERTE,FLANDRIA,FLEURS_DE_FRANCE,FODMAP,FODMAP_FRIENDLY,FOOD_ALLIANCE_CERTIFIED,FOOD_JUSTICE_CERTIFIED,FOOD_SAFETY_SYSTEM_CERTIFICATION_22000,FOODLAND_ONTARIO,FOR_LIFE,FOREST_PRODUCTS_Z809,FOREST_STEWARDSHIP_COUNCIL_100_PERCENT,FOREST_STEWARDSHIP_COUNCIL_LABEL,FOREST_STEWARDSHIP_COUNCIL_MIX,FOREST_STEWARDSHIP_COUNCIL_RECYCLED,FOUNDATION_ART,FRAN_SVERIGE,FRANCE_LIMOUSIN_MEAT,FREILAND,FRESHCARE,FRIEND_OF_THE_SEA,FRUITS_ET_LEGUMES_DE_FRANCE,GAEA,GANEDEN_BC30_PROBIOTIC,GAP_1,GAP_2,GAP_3,GAP_4,GAP_5,GAP_5_PLUS,GASKEUR,GASTEC,GCP,GEBANA,GENUSS_REGION_AUSTRIA,GENUSS_REGION_AUSTRIA,GEPRUEFTE_SICHERHEIT,GEZONDERE_KEUZE,GFCO,GFCO,GFCP,GIG_GLUTEN_FREE_FOODSERVICE,GLOBAL_CARE,GLOBAL_GAP,GLOBAL_ORGANIC_LATEX_STANDARD,GLOBAL_ORGANIC_TEXTILE_STANDARD,GLOBAL_RECYCLED_STANDARD,GLYCAMIC_INDEX_FOUNDATION,GLYCAMIC_RESEARCH_INSTITUTE,GMO_GUARD_FROM_NATURAL_FOOD_CERTIFIERS,GMO_MARKED,GMP_CERTIFIED,GMP_ISO_22716,GOA_ORGANIC,GODKAND_FOR_EKOLOGISK_ODLING_KRAV,GOOD_HOUSEKEEPING,GOODS_FROM_FINLAND_BLUE_SWAN,GOODWEAVE,GRASKEURMERK,GRASP,GREEN_AMERICA_CERTIFIED_BUSINESS,GREEN_DOT,GREEN_E_ENERGY_CERT,GREEN_E_ORG,GREEN_RESTAURANT_ASSOCIATION_ENDORSED,GREEN_SEAL,GREEN_SEAL_CERTIFIED,GREEN_SHIELD_CERTIFIED,GREEN_STAR_CERTIFIED,GREENCHOICE,GROEN_LABEL_KAS,GRUYERE_FRANCE,GUARANTEED_IRISH,HALAL_AUSTRALIA,HALAL_CERTIFICATION_SERVICES,HALAL_CERTIFICATION_SERVICES_CH,HALAL_CORRECT,HALAL_FOOD_COUNCIL_OF_SOUTH_EAST_ASIA_THAILAND,HALAL_HIC,HALAL_HPDS,HALAL_INDIA,HALAL_ISLAMIC_FOOD_CANADA,HALAL_ISLAMIC_SOCIETY_OF_NORTH_AMERICA,HALAL_PLUS,HAUTE_VALEUR_ENVIRONNEMENTALE,HAZARD_ANALYSIS_CRITICAL_CONTROL_POINT,HEALTH_CHECK,HEALTH_FOOD_BLUE_HAT_SIGN,HEUMILCH,HFAC_HUMANE,HMCA_HALAL_MONTREAL_CERTIFICATION_AUTHORITY,HOCHSTAMM_SUISSE,HOW_2_RECYCLE,HUMANE_HEARTLAND,HYPERTENSION_CANADA_MEDICAL_DEVICE,ICADA,ICEA,ICELAND_RESPONSIBLE_FISHERIES,ICS_ORGANIC,IFANCA_HALAL,IFOAM,IFS_HPC,IGP,IHTK_SEAL,IKB_EIEREN,IKB_KIP,IKB_VARKEN,INDEKLIMA_MAERKET,INSTITUT_FRESENIUS,INT_PROTECTION,INTEGRITY_AND_SUSTAINABILITY_CERTIFIED,INTERNATIONAL_ALOE_SCIENCE_COUNCIL_CERTIFICATE,INTERNATIONAL_KOSHER_COUNCIL,INTERNATIONAL_TASTE_QUALITY,INTERTEK_CERTIFICATE,INTERTEK_ETL,IP_SUISSE,ISCC,ISCC_SUPPORTING_THE_BIOECONOMY,ISEAL_ALLIANCE,ISO_QUALITY,IVN_NATURAL_LEATHER,IVN_NATURAL_TEXTILES_BEST,IVO_OMEGA3,JAS_ORGANIC,JAY_KOSHER_PAREVE,JODSALZ_BZGA,KABELKEUR,KAGFREILAND,KEHILLA_KOSHER_CALIFORNIA_K,KEHILLA_KOSHER_HEART_K,KEMA_KEUR,KIWA,KLASA,KOF_K_KOSHER,KOMO,KOSHER_AUSTRALIA,KOSHER_BDMC,KOSHER_CERTIFICATION_SERVICE,KOSHER_CHECK,KOSHER_CHICAGO_RABBINICAL_COUNCIL_DAIRY,KOSHER_CHICAGO_RABBINICAL_COUNCIL_PAREVE,KOSHER_COR_DAIRY,KOSHER_COR_DAIRY_EQUIPMENT,KOSHER_COR_FISH,KOSHER_EIDAH_HACHAREIDIS,KOSHER_GRAND_RABBINATE_OF_QUEBEC_PARVE,KOSHER_GREECE,KOSHER_INSPECTION_SERVICE_INDIA,KOSHER_KW_YOUNG_ISRAEL_OF_WEST_HEMPSTEAD,KOSHER_MADRID_SPAIN,KOSHER_OK_DAIRY,KOSHER_ORGANICS,KOSHER_ORTHODOX_JEWISH_CONGREGATION_PARVE,KOSHER_OTTAWA_VAAD_HAKASHRUT_CANADA,KOSHER_PARVE_BKA,KOSHER_PARVE_NATURAL_FOOD_CERTIFIER,KOSHER_PERU,KOSHER_RAV_LANDAU,KOSHER_STAR_K_PARVE,KOSHER_STAR_K_PARVE_PASSOVER,KOSHER_STAR_S_P_KITNIYOT,KOSHERMEX,KOTT_FRAN_SVERIGE,KRAV_MARK,KSA_KOSHER,KSA_KOSHER_DAIRY,KVBG_APPROVED,LAATUVASTUU,LABEL_OF_THE_ALLERGY_AND_ASTHMA_FEDERATION,LABEL_ROUGE,LACON,LAENDLE_QUALITAET,LAIT_COLLECTE_ET_CONDITIONNE_EN_FRANCE,LAIT_COLLECTE_ET_TRANSFORME_EN_FRANCE,LAPIN_DE_FRANCE,LE_PORC_FRANCAIS,LEAPING_BUNNY,LEGUMES_DE_FRANCE,LETIS_ORGANIC,LGA,LOCALIZE,LODI_RULES_CODE,LONDON_BETH_DIN_KOSHER,LOODUSSOBRALIK_TOODE_ESTONIA,LOVE_IRISH_FOOD,LVA,MADE_GREEN_IN_ITALY,MADE_IN_FINLAND_FLAG_WITH_KEY,MADE_OF_PLASTIC_BEVERAGE_CUPS,MADE_WITH_CANADIAN_BEEF,MAITRE_ARTISAN,MARINE_STEWARDSHIP_COUNCIL_LABEL,MAX_HAVELAAR,MCIA_ORGANIC,MEHR_WEG,MIDWEST_KOSHER,MILIEUKEUR,MINNESOTA_KOSHER_COUNCIL,MJOLK_FRAN_SVERIGE,MOMS_CHOICE_AWARD,MONTREAL_VAAD_HAIR_MK_PAREVE,MORTADELLA_BOLOGNA,MPS_A,MUNDUSVINI_GOLD,MUNDUSVINI_SILVER,MUSLIM_JUDICIAL_COUNCIL_HALAAL_TRUST,MY_CLIMATE,NAOOA_CERTIFIED_QUALITY,NASAA_CERTIFIED_ORGANIC,NATRUE_LABEL,NATURA_BEEF,NATURA_VEAL,NATURE_CARE_PRODUCT,NATURE_ET_PROGRES,NATUREPLUS,NATURLAND,NATURLAND_FAIR_TRADE,NATURLAND_WILDFISH,NC_NATURAL_COSMETICS_STANDARD,NC_NATURAL_COSMETICS_STANDARD_ORGANIC_QUALITY,NC_VEGAN_NATURAL_COSMETICS,NC_VEGAN_NATURAL_COSMETICS_STANDARD_ORGANIC_QUALITY,NCA_GLUTEN_FREE,NDOA,NEA,NEULAND,NEW_ZEALAND_SUSTAINABLE_WINEGROWING,NF_MARQUE,NFCA_GLUTEN_FREE,NIX18,NMX,NOM,NON_GMO_BY_EARTHKOSHER,NON_GMO_PROJECT,NPA,NSF,NSF_CERTIFIED_FOR_SPORT,NSF_GLUTEN_FREE,NSF_NON_GMO_TRUE_NORTH,NSF_SUSTAINABILITY_CERTIFIED,NSM,NYCKELHALET,OCEAN_WISE,OCIA,OCQV_ORGANIC,OECD_BIO_INGREDIENTS,OEKO_CONTROL,OEKO_KREISLAUF,OEKO_QUALITY_GUARANTEE_BAVARIA,OEKO_TEX_LABEL,OEKO_TEX_MADE_IN_GREEN,OEUFS_DE_FRANCE,OFF_ORGANIC,OFFICIAL_ECO_LABEL_SUN,OFG_ORGANIC,OHNE_GEN_TECHNIK,OK_COMPOST_HOME,OK_COMPOST_INDUSTRIAL ,OK_COMPOST_VINCOTTE,OK_KOSHER,OKOTEST,ON_THE_WAY_TO_PLANETPROOF,ONE_PERCENT_FOR_THE_PLANET,ONTARIO_APPROVED,ONTARIO_PORK,ORB,ORBI,OREGON_KOSHER,OREGON_LIVE,OREGON_TILTH,ORGANIC_100_CONTENT_STANDARD,ORGANIC_COTTON,ORGANIC_TRADE_ASSOCIATION,ORIGIN_OF_EGGS,ORIGINE_FRANCE_GARANTIE,ORTHODOX_UNION,OTCO_ORGANIC,OU_KOSHER,OU_KOSHER_DAIRY,OU_KOSHER_FISH,OU_KOSHER_MEAT,OU_KOSHER_PASSOVER,OZONE_FRIENDLY_GENERAL_CLAIM,PACS_ORGANIC,PALEO_APPROVED,PALEO_BY_EARTHKOSHER,PARENT_TESTED_PARENT_APPROVED,PAVILLON_FRANCE,PCO,PEFC,PEFC_CERTIFIED,PEFC_RECYCLED,PET_TO_PET,PGI_CNIPA,PGI_GAQSIQ,PGI_MARA,PGI_TO_SAIC,PLASTIC_FREE_TRUST_MARK,PLASTIC_IN_FILTER_TOBACCO,PLASTIC_IN_PRODUCT_BEVERAGE_CUPS,PLASTIC_IN_PRODUCT_TAMPONS,PLASTIC_IN_PRODUCT_WIPES_SANITARY_PADS,PLASTIC_NEUTRAL,POMMES_DE_TERRES_DE_FRANCE,PREGNANCY_WARNING,PRO_SPECIE_RARA,PRO_TERRA_NON-GMO_CERTIFICATION,PROCERT_ORGANIC,PRODERM,PRODUCT_OF_THE_YEAR_CONSUMER_SURVEY,PRODUIT_EN_BRETAGNE,PROTECTED_DESIGNATION_OF_ORIGIN,PROTECTED_GEOGRAPHICAL_INDICATION,PROTECTED_HARVEST_CERTIFIED,PROVEN_QUALITY_BAVARIA,PUHTAASTI_KOTIMAINEN,QAI,QCS_ORGANIC,QS,QS_PRODUCTION_PERMIT,QUALENVI,QUALITAET_TIROL,QUALITY_CONFORMANCE_MARKING_CN,QUALITY_MARK_IRELAND,QUALITY_RHOEN,RABBINICAL_COUNCIL_OF_BRITISH_COLUMBIA,RABBINICAL_COUNCIL_OF_CALIFORNIA_(RCC),RABBINICAL_COUNCIL_OF_NEW_ENGLAND,RAINFOREST_ALLIANCE,RAINFOREST_ALLIANCE_PEOPLE_NATURE,RAL_QUALITY_CANDLES,REAL_CALIFORNIA_CHEESE,REAL_CALIFORNIA_MILK,REAL_FOOD_SEAL,RECUPEL,RECYCLABLE_GENERAL_CLAIM,REGIONAL_FOOD_CZECH,REGIONALFENSTER,REGIONALTHEKE_FRANKEN,RETURNABLE_PET_BOTTLE_NL,RHP,ROQUEFORT_RED_EWE,ROUNDTABLE_ON_RESPONSIBLE_SOY,RSB,RUP_GUADELOUPE,RUP_GUYANE,RUP_MARTINIQUE,RUP_MAYOTTE,RUP_REUNION,RUP_SAINT_MARTIN,SA8000,SAFE_FEED_SAFE_FOOD,SAFE_QUALITY_FOOD,SAFER_CHOICE,SALMON_SAFE_CERTIFICATION,SALZBURGER_LAND_HERKUNFT,SCHARRELVLEES,SCHLESWIG_HOLSTEIN_QUALITY,SCROLL_K,SCS_RECYCLED_CONTENT_CERTIFICATION,SCS_SUSTAINABLY_GROWN,SEACHOICE,SFC_MEMBER_SEAL,SFC_MEMBER_SEAL_GOLD,SFC_MEMBER_SEAL_PLATINUM,SFC_MEMBER_SEAL_SILVER,SGS_ORGANIC,SHOPPER_ARMY,SIP,SKG_CERTIFICATE,SKG_CERTIFICATE_1_STAR,SKG_CERTIFICATE_2_STAR,SKG_CERTIFICATE_3_STAR,SLG_CHILD_SAFETY,SLG_TYPE_TESTED,SLK_BIO,SOCIETY_PLASTICS_INDUSTRY,SOIL_ASSOCIATION_ORGANIC_SYMBOL,SOIL_COSMOS_NATURAL,SOIL_ORGANIC_COSMOS,SOSTAIN,SPCA_BC,STAR_D_KOSHER,STAR_K_KOSHER,STEEL_RECYCLING,STELLAR_CERTIFICATION_SERVICES,STIFTUNG_WARENTEST,STOP_CLIMATE_CHANGE,STREEKPRODUCT_BE,STRICTLY_KOSHER_NORWAY,SUISSE_GARANTIE,SUNSHINE_STATE_KOSHER,SUOMEN_HAMMASLAAKARILIITTO_SUOSITTELEE_KSYLITOLIA,SUS,SUSTAINABLE_AUSTRALIA_WINEGROWING,SUSTAINABLE_AUSTRIA,SUSTAINABLE_FORESTRY_INITIATIVE,SUSTAINABLE_PALM_OIL_RSPO,SUSTAINABLE_PALM_OIL_RSPO_CREDITS,SUSTAINABLE_PALM_OIL_RSPO_MIXED,SVANEN,SVENSK_FAGEL,SVENSKT_KOTT,SVENSKT_SIGILL_KLIMATCERTIFIERAD,SVENSKT_SIGILL_NATURBETESKOTT,SWEDISH_SEAL_OF_QUALITY,SWISS_ALLERGY_LABEL,SWISS_ALPS_PRODUCT,SWISS_MOUNTAIN_PRODUCT,SWISSGAP,SWISSMILK_GREEN,SWISSPRIMGOURMET,TARNOPOL_KASHRUS_KOSHER,TCO_DEVELOPMENT,TCO_ORGANIC,TERRA_VITIS,TERRACYCLE,THE_FAIR_RUBBER_ASSOCIATION,THE_NATURAL_AND_ORGANIC_AWARDS,THREE_LINE_KOSHER,TIERSCHUTZBUND,TNO_APPROVED,TOOTHFRIENDLY,TRADITIONAL_SPECIALTY_GUARANTEED,TRIANGLE_K,TRIMAN,TRUE_FOODS_CANADA_TRUSTMARK,TRUE_SOURCE_CERTIFIED,TUEV_GEPRUEFT,TUNNUSTATUD_EESTI_MAITSE,TUNNUSTATUD_MAITSE,UDEN_GMO_FODER,UMWELTBAUM,UNDERWRITERS_LABORATORY,UNDERWRITERS_LABORATORY_CERTIFIED_CANADA_US,UNIQUELY_FINNISH,UNITED_EGG_PRODUCERS_CERTIFIED,UNSER_LAND,URDINKEL,USDA,USDA_CERTIFIED_BIOBASED,USDA_GRADE_A,USDA_GRADE_AA,USDA_INSPECTION,USDA_ORGANIC,UTZ_CERTIFIED,UTZ_CERTIFIED_COCOA,VAAD_HOEIR_KOSHER,VAELG_FULDKORN_FORST,VDE,VDS_CERTIFICATE,VEGAN_AWARENESS_FOUNDATION,VEGAN_BY_EARTHKOSHER,VEGAN_NATURAL_FOOD_CERTIFIERS,VEGAN_SOCIETY_VEGAN_LOGO,VEGAPLAN,VEGATARIAN_SOCIETY_V_LOGO,VEGECERT,VEILIG_WONEN_POLITIE_KEURMERK,VERBUND_OEKOHOEFE,VIANDE_AGNEAU_FRANCAIS,VIANDE_BOVINE_FRANCAISE,VIANDE_CHEVALINE_FRANCAISE,VIANDE_DE_CHEVRE_FRANCAISE,VIANDE_DE_CHEVREAU_FRANCAISE,VIANDE_DE_VEAU_FRANCAISE,VIANDE_OVINE_FRANCAISE,VIANDES_DE_FRANCE,VIGNERONS_EN_DEVELOPPEMENT_DURABLE,VIM_CO_JIM,VINATURA,VINHO_VERDE,VITICULTURE_DURABLE_EN_CHAMPAGNE,VIVA,VOLAILLE_FRANCAISE,WARRANT_HOLDER_OF_THE_COURT_OF_BELGIUM,WEIDEMELK,WEIGHT_WATCHERS_ENDORSED,WESTERN_KOSHER,WHOLE_GRAIN_100_PERCENT_STAMP,WHOLE_GRAIN_BASIC_STAMP,WHOLE_GRAIN_COUNCIL_STAMP,WHOLE_GRAINS_50_PERCENT_STAMP,WIETA (Wine and Agricultural Ethical Trading Association),WINERIES_FOR_CLIMATE_PROTECTION,WISCONSIN_K,WQA_TESTED_CERTIFIED_WATER,WSDA,WWF_PANDA_LABEL,ZELDZAAM_LEKKER,ZERO_WASTE_BUSINESS_COUNCIL_CERTIFIED,'" />
  <xsl:template match="text()" mode="M10" priority="-1" />
  <xsl:template match="@*|node()" mode="M10" priority="-2">
    <xsl:apply-templates mode="M10" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN abstracts-->


	<!--RULE -->
<xsl:template match="//*[@currencyID]" mode="M12" priority="1060">
    <svrl:fired-rule context="//*[@currencyID]" />
    <xsl:apply-templates mode="M12" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M12" priority="-1" />
  <xsl:template match="@*|node()" mode="M12" priority="-2">
    <xsl:apply-templates mode="M12" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN ublextensions-->


	<!--RULE -->
<xsl:template match="doc:Reminder" mode="M13" priority="1000">
    <svrl:fired-rule context="doc:Reminder" />

		<!--REPORT -->
<xsl:if test="ext:UBLExtensions/ext:UBLExtension/ext:ExtensionAgencyID = 'Digitaliseringsstyrelsen' and (ext:UBLExtensions/ext:UBLExtension/cbc:ID &lt; '1001' or ext:UBLExtensions/ext:UBLExtension/cbc:ID > '1999')">
      <svrl:successful-report test="ext:UBLExtensions/ext:UBLExtension/ext:ExtensionAgencyID = 'Digitaliseringsstyrelsen' and (ext:UBLExtensions/ext:UBLExtension/cbc:ID &lt; '1001' or ext:UBLExtensions/ext:UBLExtension/cbc:ID > '1999')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB313] Invalid UBLExtension/ID when UBLExtension/ExtensionAgencyID is equal to 'Digitaliseringsstyrelsen'. ID must be an assigned value between '1001' and '1999'.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M13" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M13" priority="-1" />
  <xsl:template match="@*|node()" mode="M13" priority="-2">
    <xsl:apply-templates mode="M13" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN profile-->


	<!--RULE -->
<xsl:template match="/" mode="M14" priority="1001">
    <svrl:fired-rule context="/" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="local-name(*) = 'Reminder'" />
      <xsl:otherwise>
        <svrl:failed-assert test="local-name(*) = 'Reminder'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-REM001] Root element must be Reminder</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="namespace-uri(*) = 'urn:oasis:names:specification:ubl:schema:xsd:Reminder-2'" />
      <xsl:otherwise>
        <svrl:failed-assert test="namespace-uri(*) = 'urn:oasis:names:specification:ubl:schema:xsd:Reminder-2'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-REM096] The documenttype does not match an OIOUBL Reminder and can not be validated by this schematron.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M14" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder" mode="M14" priority="1000">
    <svrl:fired-rule context="doc:Reminder" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:UBLVersionID = '2.0' or cbc:UBLVersionID = '2.1'" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:UBLVersionID = '2.0' or cbc:UBLVersionID = '2.1'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB001] Invalid UBLVersionID. Must be '2.0' or '2.1'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:CustomizationID='OIOUBL-2.01' or cbc:CustomizationID='OIOUBL-2.02' or cbc:CustomizationID='OIOUBL-2.1'" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:CustomizationID='OIOUBL-2.01' or cbc:CustomizationID='OIOUBL-2.02' or cbc:CustomizationID='OIOUBL-2.1'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB002]Invalid CustomizationID. Must be either 'OIOUBL-2.01', 'OIOUBL-2.02' or 'OIOUBL-2.1'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ProfileID/@schemeID = $Profile1_schemeID or cbc:ProfileID/@schemeID = $Profile2_schemeID or cbc:ProfileID/@schemeID = $Profile3_schemeID or cbc:ProfileID/@schemeID = $Profile4_schemeID or cbc:ProfileID/@schemeID = $Profile5_schemeID or cbc:ProfileID/@schemeID = $Profile6_schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ProfileID/@schemeID = $Profile1_schemeID or cbc:ProfileID/@schemeID = $Profile2_schemeID or cbc:ProfileID/@schemeID = $Profile3_schemeID or cbc:ProfileID/@schemeID = $Profile4_schemeID or cbc:ProfileID/@schemeID = $Profile5_schemeID or cbc:ProfileID/@schemeID = $Profile6_schemeID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[W-LIB003] Invalid schemeID. Must be '<xsl:text />
            <xsl:value-of select="$Profile1_schemeID" />
            <xsl:text />' or '<xsl:text />
            <xsl:value-of select="$Profile2_schemeID" />
            <xsl:text />' or '<xsl:text />
            <xsl:value-of select="$Profile3_schemeID" />
            <xsl:text />' or '<xsl:text />
            <xsl:value-of select="$Profile4_schemeID" />
            <xsl:text />' or '<xsl:text />
            <xsl:value-of select="$Profile5_schemeID" />
            <xsl:text />' or '<xsl:text />
            <xsl:value-of select="$Profile6_schemeID" />
            <xsl:text />'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ProfileID/@schemeAgencyID = $Profile1_agencyID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ProfileID/@schemeAgencyID = $Profile1_agencyID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[W-LIB203] Invalid schemeAgencyID. Must be '<xsl:text />
            <xsl:value-of select="$Profile1_agencyID" />
            <xsl:text />'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="cbc:ProfileID/@schemeID = $Profile1_schemeID and not (contains($Profile1, concat(',',cbc:ProfileID,',')))">
      <svrl:successful-report test="cbc:ProfileID/@schemeID = $Profile1_schemeID and not (contains($Profile1, concat(',',cbc:ProfileID,',')))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB004] Invalid ProfileID: '<xsl:text />
          <xsl:value-of select="cbc:ProfileID" />
          <xsl:text />'. Must be a value from the codelist</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:ProfileID/@schemeID = $Profile2_schemeID and not (contains($Profile2, concat(',',cbc:ProfileID,',')))">
      <svrl:successful-report test="cbc:ProfileID/@schemeID = $Profile2_schemeID and not (contains($Profile2, concat(',',cbc:ProfileID,',')))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB302] Invalid ProfileID: '<xsl:text />
          <xsl:value-of select="cbc:ProfileID" />
          <xsl:text />'. Must be a value from the codelist</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:ProfileID/@schemeID = $Profile3_schemeID and not (contains($Profile3, concat(',',cbc:ProfileID,',')))">
      <svrl:successful-report test="cbc:ProfileID/@schemeID = $Profile3_schemeID and not (contains($Profile3, concat(',',cbc:ProfileID,',')))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB308] Invalid ProfileID: '<xsl:text />
          <xsl:value-of select="cbc:ProfileID" />
          <xsl:text />'. Must be a value from the codelist</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:ProfileID/@schemeID = $Profile4_schemeID and not (contains($Profile4, concat(',',cbc:ProfileID,',')))">
      <svrl:successful-report test="cbc:ProfileID/@schemeID = $Profile4_schemeID and not (contains($Profile4, concat(',',cbc:ProfileID,',')))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB325] Invalid ProfileID: '<xsl:text />
          <xsl:value-of select="cbc:ProfileID" />
          <xsl:text />'. Must be a value from the codelist</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:ProfileID/@schemeID = $Profile5_schemeID and not (contains($Profile5, concat(',',cbc:ProfileID,',')))">
      <svrl:successful-report test="cbc:ProfileID/@schemeID = $Profile5_schemeID and not (contains($Profile5, concat(',',cbc:ProfileID,',')))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB327] Invalid ProfileID: '<xsl:text />
          <xsl:value-of select="cbc:ProfileID" />
          <xsl:text />'. Must be a value from the codelist</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:ProfileID/@schemeID = $Profile6_schemeID and not (contains($Profile6, concat(',',cbc:ProfileID,',')))">
      <svrl:successful-report test="cbc:ProfileID/@schemeID = $Profile6_schemeID and not (contains($Profile6, concat(',',cbc:ProfileID,',')))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB351] Invalid ProfileID: '<xsl:text />
          <xsl:value-of select="cbc:ProfileID" />
          <xsl:text />'. Must be a value from the codelist</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:variable name="Profile" select="cbc:ProfileID" />
    <xsl:variable name="Document" select="local-name(/*)" />

		<!--REPORT -->
<xsl:if test="($Profile = 'Procurement-OrdRes-1.0') and not ($Document = 'OrderResponse')">
      <svrl:successful-report test="($Profile = 'Procurement-OrdRes-1.0') and not ($Document = 'OrderResponse')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB328] The profile '<xsl:text />
          <xsl:value-of select="$Profile" />
          <xsl:text />' is not allowed in the document type '<xsl:text />
          <xsl:value-of select="$Document" />
          <xsl:text />'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="($Profile = 'Procurement-BilSimReminderOnly-1.0') and not ($Document = 'Reminder')">
      <svrl:successful-report test="($Profile = 'Procurement-BilSimReminderOnly-1.0') and not ($Document = 'Reminder')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB352] The profile '<xsl:text />
          <xsl:value-of select="$Profile" />
          <xsl:text />' is not allowed in the document type '<xsl:text />
          <xsl:value-of select="$Document" />
          <xsl:text />'</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M14" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M14" priority="-1" />
  <xsl:template match="@*|node()" mode="M14" priority="-2">
    <xsl:apply-templates mode="M14" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN reminder-->


	<!--RULE -->
<xsl:template match="doc:Reminder" mode="M15" priority="1007">
    <svrl:fired-rule context="doc:Reminder" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:TaxPointDate) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:TaxPointDate) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-REM002] TaxPointDate element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:LineCountNumeric) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:LineCountNumeric) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-REM003] LineCountNumeric element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ReminderTypeCode != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ReminderTypeCode != ''">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-REM006] Invalid ReminderTypeCode. Must contain a value</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:ReminderSequenceNumeric) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:ReminderSequenceNumeric) != ''">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-REM007] Invalid ReminderSequenceNumeric. Must contain a value</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:DocumentCurrencyCode != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:DocumentCurrencyCode != ''">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-REM008] Invalid DocumentCurrencyCode. Must contain a value</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:ID) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:ID) != ''">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-REM010] Invalid ID. Must contain a value</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ReminderTypeCode/@listID = 'urn:oioubl.codelist:remindertypecode-1.1' or cbc:ReminderTypeCode/@listID = 'urn:oioubl:codelist:remindertypecode-1.1'" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ReminderTypeCode/@listID = 'urn:oioubl.codelist:remindertypecode-1.1' or cbc:ReminderTypeCode/@listID = 'urn:oioubl:codelist:remindertypecode-1.1'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-REM059] Invalid listID. Must be 'urn:oioubl.codelist:remindertypecode-1.1' or 'urn:oioubl:codelist:remindertypecode-1.1'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ReminderTypeCode/@listAgencyID = '320'" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ReminderTypeCode/@listAgencyID = '320'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-REM060] Invalid listAgencyID. Must be '320'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ReminderTypeCode = 'Reminder' or cbc:ReminderTypeCode = 'Advis'" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ReminderTypeCode = 'Reminder' or cbc:ReminderTypeCode = 'Advis'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-REM061] Invalid ReminderTypeCode. Must be a value from the codelist</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="cbc:AccountingCost and cbc:AccountingCostCode">
      <svrl:successful-report test="cbc:AccountingCost and cbc:AccountingCostCode">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB021] Use either AccountingCost or AccountingCostCode</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="count(cac:ReminderPeriod) > 1">
      <svrl:successful-report test="count(cac:ReminderPeriod) > 1">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-REM070] No more than one ReminderPeriod class may be present</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M15" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cbc:UUID" mode="M15" priority="1006">
    <svrl:fired-rule context="doc:Reminder/cbc:UUID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(string(.)) = 36" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(string(.)) = 36">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB006] Invalid <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />. Must be of this form '6E09886B-DC6E-439F-82D1-7CCAC7F4E3B1'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M15" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cbc:Note" mode="M15" priority="1005">
    <svrl:fired-rule context="doc:Reminder/cbc:Note" />

		<!--REPORT -->
<xsl:if test="count(../cbc:Note) > 1 and not(./@languageID)">
      <svrl:successful-report test="count(../cbc:Note) > 1 and not(./@languageID)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[W-LIB011] The attribute languageID should be used when more than one <xsl:text />
          <xsl:value-of select="name(.)" />
          <xsl:text /> element is present</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID">
      <svrl:successful-report test="local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[W-LIB012] Multilanguage error. Replicated <xsl:text />
          <xsl:value-of select="name(.)" />
          <xsl:text /> elements with same languageID attribute value</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M15" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cbc:DocumentCurrencyCode" mode="M15" priority="1004">
    <svrl:fired-rule context="doc:Reminder/cbc:DocumentCurrencyCode" />

		<!--REPORT -->
<xsl:if test="/*/cac:ReminderLine/cbc:DebitLineAmount[@currencyID][@currencyID!=string(current())]">
      <svrl:successful-report test="/*/cac:ReminderLine/cbc:DebitLineAmount[@currencyID][@currencyID!=string(current())]">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-REM067] There is a DebitLineAmount for one or more Reminder lines where the currencyID does not equal the DocumentCurrencyCode</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="/*/cac:ReminderLine/cbc:CreditLineAmount[@currencyID][@currencyID!=string(current())]">
      <svrl:successful-report test="/*/cac:ReminderLine/cbc:CreditLineAmount[@currencyID][@currencyID!=string(current())]">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-REM068] There is a CreditLineAmount for one or more Reminder lines where the currencyID does not equal the DocumentCurrencyCode</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="/*/cac:LegalMonetaryTotal/cbc:LineExtensionAmount[@currencyID][@currencyID!=string(current())]">
      <svrl:successful-report test="/*/cac:LegalMonetaryTotal/cbc:LineExtensionAmount[@currencyID][@currencyID!=string(current())]">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-REM065] There is a LineExtensionAmount where the currencyID does not equal the DocumentCurrencyCode</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="/*/cac:LegalMonetaryTotal/cbc:PayableAmount[@currencyID][@currencyID!=string(current())]">
      <svrl:successful-report test="/*/cac:LegalMonetaryTotal/cbc:PayableAmount[@currencyID][@currencyID!=string(current())]">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-REM066] There is a PayableAmount where the currencyID does not equal the DocumentCurrencyCode</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="./@listID and ./@listID != $CurrencyCode_listID">
      <svrl:successful-report test="./@listID and ./@listID != $CurrencyCode_listID">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB296] Invalid listID. Must be '<xsl:text />
          <xsl:value-of select="$CurrencyCode_listID" />
          <xsl:text />'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="./@listAgencyID and ./@listAgencyID != $CurrencyCode_agencyID">
      <svrl:successful-report test="./@listAgencyID and ./@listAgencyID != $CurrencyCode_agencyID">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB297] Invalid listAgencyID. Must be '<xsl:text />
          <xsl:value-of select="$CurrencyCode_agencyID" />
          <xsl:text />'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="contains($CurrencyCode, concat(',',.,','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="contains($CurrencyCode, concat(',',.,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB298] Invalid CurrencyCode: '<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />'. Must be a value from the codelist</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M15" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cbc:TaxCurrencyCode" mode="M15" priority="1003">
    <svrl:fired-rule context="doc:Reminder/cbc:TaxCurrencyCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test=".='DKK' or . ='EUR'" />
      <xsl:otherwise>
        <svrl:failed-assert test=".='DKK' or . ='EUR'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-REM012] TaxCurrencyCode must be either DKK or EUR</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(/*/cac:TaxTotal/cac:TaxSubtotal/cbc:TransactionCurrencyTaxAmount) != 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(/*/cac:TaxTotal/cac:TaxSubtotal/cbc:TransactionCurrencyTaxAmount) != 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-REM014] One TransactionCurrencyTaxAmount element must be present when TaxCurrencyCode element is used</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M15" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cbc:PricingCurrencyCode" mode="M15" priority="1002">
    <svrl:fired-rule context="doc:Reminder/cbc:PricingCurrencyCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(/*/cac:PricingExchangeRate) != 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(/*/cac:PricingExchangeRate) != 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-REM062] One PricingExchangeRate class must be present when PricingCurrencyCode element is used</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="./@listID and ./@listID != $CurrencyCode_listID">
      <svrl:successful-report test="./@listID and ./@listID != $CurrencyCode_listID">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB296] Invalid listID. Must be '<xsl:text />
          <xsl:value-of select="$CurrencyCode_listID" />
          <xsl:text />'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="./@listAgencyID and ./@listAgencyID != $CurrencyCode_agencyID">
      <svrl:successful-report test="./@listAgencyID and ./@listAgencyID != $CurrencyCode_agencyID">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB297] Invalid listAgencyID. Must be '<xsl:text />
          <xsl:value-of select="$CurrencyCode_agencyID" />
          <xsl:text />'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="contains($CurrencyCode, concat(',',.,','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="contains($CurrencyCode, concat(',',.,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB298] Invalid CurrencyCode: '<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />'. Must be a value from the codelist</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M15" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cbc:PaymentCurrencyCode" mode="M15" priority="1001">
    <svrl:fired-rule context="doc:Reminder/cbc:PaymentCurrencyCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(/*/cac:PaymentExchangeRate) != 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(/*/cac:PaymentExchangeRate) != 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-REM063] One PaymentExchangeRate class must be present when PaymentCurrencyCode element is used</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="./@listID and ./@listID != $CurrencyCode_listID">
      <svrl:successful-report test="./@listID and ./@listID != $CurrencyCode_listID">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB296] Invalid listID. Must be '<xsl:text />
          <xsl:value-of select="$CurrencyCode_listID" />
          <xsl:text />'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="./@listAgencyID and ./@listAgencyID != $CurrencyCode_agencyID">
      <svrl:successful-report test="./@listAgencyID and ./@listAgencyID != $CurrencyCode_agencyID">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB297] Invalid listAgencyID. Must be '<xsl:text />
          <xsl:value-of select="$CurrencyCode_agencyID" />
          <xsl:text />'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="contains($CurrencyCode, concat(',',.,','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="contains($CurrencyCode, concat(',',.,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB298] Invalid CurrencyCode: '<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />'. Must be a value from the codelist</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M15" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cbc:PaymentAlternativeCurrencyCode" mode="M15" priority="1000">
    <svrl:fired-rule context="doc:Reminder/cbc:PaymentAlternativeCurrencyCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(/*/cac:PaymentAlternativeExchangeRate) != 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(/*/cac:PaymentAlternativeExchangeRate) != 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-REM064] One PaymentAlternativeExchangeRate class must be present when PaymentAlternativeCurrencyCode element is used</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="./@listID and ./@listID != $CurrencyCode_listID">
      <svrl:successful-report test="./@listID and ./@listID != $CurrencyCode_listID">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB296] Invalid listID. Must be '<xsl:text />
          <xsl:value-of select="$CurrencyCode_listID" />
          <xsl:text />'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="./@listAgencyID and ./@listAgencyID != $CurrencyCode_agencyID">
      <svrl:successful-report test="./@listAgencyID and ./@listAgencyID != $CurrencyCode_agencyID">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB297] Invalid listAgencyID. Must be '<xsl:text />
          <xsl:value-of select="$CurrencyCode_agencyID" />
          <xsl:text />'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="contains($CurrencyCode, concat(',',.,','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="contains($CurrencyCode, concat(',',.,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB298] Invalid CurrencyCode: '<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />'. Must be a value from the codelist</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M15" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M15" priority="-1" />
  <xsl:template match="@*|node()" mode="M15" priority="-2">
    <xsl:apply-templates mode="M15" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN reminderperiod-->


	<!--RULE -->
<xsl:template match="doc:Reminder/cac:ReminderPeriod" mode="M16" priority="1001">
    <svrl:fired-rule context="doc:Reminder/cac:ReminderPeriod" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:DurationMeasure) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:DurationMeasure) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB076] DurationMeasure element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:DescriptionCode) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:DescriptionCode) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB077] DescriptionCode element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:StartTime) and (not(cbc:StartDate) or cbc:StartDate = '')">
      <svrl:successful-report test="(cbc:StartTime) and (not(cbc:StartDate) or cbc:StartDate = '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB078] There must be a StartDate if you have a StartTime</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:EndTime) and (not(cbc:EndDate) or cbc:EndDate = '')">
      <svrl:successful-report test="(cbc:EndTime) and (not(cbc:EndDate) or cbc:EndDate = '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB079] There must be a EndDate if you have a EndTime</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:StartDate and cbc:EndDate) and not(number(translate(cbc:EndDate,'-','')) > number(translate(cbc:StartDate,'-','')) or number(translate(cbc:EndDate,'-','')) = number(translate(cbc:StartDate,'-','')))">
      <svrl:successful-report test="(cbc:StartDate and cbc:EndDate) and not(number(translate(cbc:EndDate,'-','')) > number(translate(cbc:StartDate,'-','')) or number(translate(cbc:EndDate,'-','')) = number(translate(cbc:StartDate,'-','')))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB080] The EndDate must be greater or equal to the startdate</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:StartTime and cbc:EndTime) and not(number(translate(cbc:EndTime,':','')) > number(translate(cbc:StartTime,':','')) or number(translate(cbc:EndTime,':','')) = number(translate(cbc:StartTime,':','')))">
      <svrl:successful-report test="(cbc:StartTime and cbc:EndTime) and not(number(translate(cbc:EndTime,':','')) > number(translate(cbc:StartTime,':','')) or number(translate(cbc:EndTime,':','')) = number(translate(cbc:StartTime,':','')))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB081] EndTime must be greater or equal to StartTime</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M16" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:ReminderPeriod/cbc:Description" mode="M16" priority="1000">
    <svrl:fired-rule context="doc:Reminder/cac:ReminderPeriod/cbc:Description" />

		<!--REPORT -->
<xsl:if test="count(../cbc:Description) > 1 and not(./@languageID)">
      <svrl:successful-report test="count(../cbc:Description) > 1 and not(./@languageID)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[W-LIB222] The attribute languageID should be used when more than one Description element is present</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID">
      <svrl:successful-report test="local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[W-LIB223] Multilanguage error. Replicated Description elements with same languageID attribute value</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M16" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M16" priority="-1" />
  <xsl:template match="@*|node()" mode="M16" priority="-2">
    <xsl:apply-templates mode="M16" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN additionaldocumentreference-->


	<!--RULE -->
<xsl:template match="doc:Reminder/cac:AdditionalDocumentReference" mode="M17" priority="1000">
    <svrl:fired-rule context="doc:Reminder/cac:AdditionalDocumentReference" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:DocumentType or cbc:DocumentTypeCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:DocumentType or cbc:DocumentTypeCode">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB092] Use either DocumentType or DocumentTypeCode</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="cac:Attachment and cbc:XPath">
      <svrl:successful-report test="cac:Attachment and cbc:XPath">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB093] Use either Attachment or XPath</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Attachment/cbc:EmbeddedDocumentBinaryObject and cac:Attachment/cac:ExternalReference">
      <svrl:successful-report test="cac:Attachment/cbc:EmbeddedDocumentBinaryObject and cac:Attachment/cac:ExternalReference">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB095] Use either EmbeddedDocumentBinaryObject or ExternalReference</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:UUID and not(string-length(string(cbc:UUID)) = 36)">
      <svrl:successful-report test="cbc:UUID and not(string-length(string(cbc:UUID)) = 36)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB097] Invalid UUID. Must be of this form '6E09886B-DC6E-439F-82D1-7CCAC7F4E3B1'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Attachment/cbc:EmbeddedDocumentBinaryObject and not(cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/tiff' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/png' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/jpeg' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/gif' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/pdf' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='text/xml' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='text/csv' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.ms-excel' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.oasis.opendocument.spreadsheet')">
      <svrl:successful-report test="cac:Attachment/cbc:EmbeddedDocumentBinaryObject and not(cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/tiff' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/png' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/jpeg' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/gif' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/pdf' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='text/xml' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='text/csv' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.ms-excel' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.oasis.opendocument.spreadsheet')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB098] Attribute mimeCode must be a value from the codelist</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Attachment/cac:ExternalReference and not(cac:Attachment/cac:ExternalReference/cbc:URI != '')">
      <svrl:successful-report test="cac:Attachment/cac:ExternalReference and not(cac:Attachment/cac:ExternalReference/cbc:URI != '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB279] When using ExternalReference, URI is mandatory</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:DocumentTypeCode = 'PersonalSecure') and not (contains($PersonalSecure, concat(',',cbc:ID,',')))">
      <svrl:successful-report test="(cbc:DocumentTypeCode = 'PersonalSecure') and not (contains($PersonalSecure, concat(',',cbc:ID,',')))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB335] When DocumentTypeCode equals 'PersonalSecure', the ID must be either '1' or '2'.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M17" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M17" priority="-1" />
  <xsl:template match="@*|node()" mode="M17" priority="-2">
    <xsl:apply-templates mode="M17" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN signature-->


	<!--RULE -->
<xsl:template match="doc:Reminder/cac:Signature" mode="M18" priority="1015">
    <svrl:fired-rule context="doc:Reminder/cac:Signature" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:ID) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:ID) != ''">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-REM015] Invalid ID. Must contain a value</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M18" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:Signature/cac:SignatoryParty" mode="M18" priority="1014">
    <svrl:fired-rule context="doc:Reminder/cac:Signature/cac:SignatoryParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:MarkCareIndicator) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:MarkCareIndicator) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB166] MarkCareIndicator element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:MarkAttentionIndicator) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:MarkAttentionIndicator) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB167] MarkAttentionIndicator element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:AgentParty) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:AgentParty) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB168] AgentParty class must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="(not(cac:PartyIdentification) or cac:PartyIdentification/cbc:ID = '') and (not(cac:PartyName) or cac:PartyName/cbc:Name = '')">
      <svrl:successful-report test="(not(cac:PartyIdentification) or cac:PartyIdentification/cbc:ID = '') and (not(cac:PartyName) or cac:PartyName/cbc:Name = '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB022] PartyName/Name is mandatory if PartyIdentification/ID is not found</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:EndpointID and not(contains($EndpointID_schemeID, concat(',',cbc:EndpointID/@schemeID,',')))">
      <svrl:successful-report test="cbc:EndpointID and not(contains($EndpointID_schemeID, concat(',',cbc:EndpointID/@schemeID,',')))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB179] Invalid schemeID: '<xsl:text />
          <xsl:value-of select="cbc:EndpointID/@schemeID" />
          <xsl:text />'. Must be a value from the codelist: '<xsl:text />
          <xsl:value-of select="$EndpointID_schemeID" />
          <xsl:text />'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:EndpointID/@schemeID = 'DK:CVR') and (string-length(cbc:EndpointID) != 10 or substring(cbc:EndpointID, 1, 2) != 'DK')">
      <svrl:successful-report test="(cbc:EndpointID/@schemeID = 'DK:CVR') and (string-length(cbc:EndpointID) != 10 or substring(cbc:EndpointID, 1, 2) != 'DK')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB180] schemeID = DK:CVR, EndpointID must be a valid CVR number (like 'DK12345678', value found: '<xsl:text />
          <xsl:value-of select="cbc:EndpointID" />
          <xsl:text />')</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:EndpointID/@schemeID = 'DK:CPR') and not(string-length(cbc:EndpointID) = 10)">
      <svrl:successful-report test="(cbc:EndpointID/@schemeID = 'DK:CPR') and not(string-length(cbc:EndpointID) = 10)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB215] schemeID = DK:CPR, EndpointID must be a valid CPR number (like '1234560000', value found: '<xsl:text />
          <xsl:value-of select="cbc:EndpointID" />
          <xsl:text />')</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:EndpointID/@schemeID = 'GLN') and not(string-length(cbc:EndpointID) = 13)">
      <svrl:successful-report test="(cbc:EndpointID/@schemeID = 'GLN') and not(string-length(cbc:EndpointID) = 13)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB181] schemeID = GLN, EndpointID must be a valid GLN number (like '1234567890123', value found: '<xsl:text />
          <xsl:value-of select="cbc:EndpointID" />
          <xsl:text />')</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:EndpointID/@schemeID = 'EAN') and not(string-length(cbc:EndpointID) = 13)">
      <svrl:successful-report test="(cbc:EndpointID/@schemeID = 'EAN') and not(string-length(cbc:EndpointID) = 13)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB216] schemeID = EAN, EndpointID must be a valid EAN number (like '1234567890123', value found: '<xsl:text />
          <xsl:value-of select="cbc:EndpointID" />
          <xsl:text />')</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="count(cac:PartyLegalEntity) > 1">
      <svrl:successful-report test="count(cac:PartyLegalEntity) > 1">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-REM069] No more than one PartyLegalEntity class may be present</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M18" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:Signature/cac:SignatoryParty/cac:PartyIdentification" mode="M18" priority="1013">
    <svrl:fired-rule context="doc:Reminder/cac:Signature/cac:SignatoryParty/cac:PartyIdentification" />

		<!--REPORT -->
<xsl:if test="not(contains($PartyID_schemeID, concat(',',cbc:ID/@schemeID,',')))">
      <svrl:successful-report test="not(contains($PartyID_schemeID, concat(',',cbc:ID/@schemeID,',')))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB183] Invalid schemeID: '<xsl:text />
          <xsl:value-of select="cbc:ID/@schemeID" />
          <xsl:text />'. Must be a value from the codelist: '<xsl:text />
          <xsl:value-of select="$PartyID_schemeID" />
          <xsl:text />'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID/@schemeID = 'DK:CVR') and (string-length(cbc:ID) != 10 or substring(cbc:ID, 1, 2) != 'DK')">
      <svrl:successful-report test="(cbc:ID/@schemeID = 'DK:CVR') and (string-length(cbc:ID) != 10 or substring(cbc:ID, 1, 2) != 'DK')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB184] schemeID = DK:CVR, ID must be a valid CVR number (like 'DK12345678', value found: '<xsl:text />
          <xsl:value-of select="cbc:ID" />
          <xsl:text />')</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID/@schemeID = 'DK:CPR') and not(string-length(cbc:ID) = 10)">
      <svrl:successful-report test="(cbc:ID/@schemeID = 'DK:CPR') and not(string-length(cbc:ID) = 10)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB217] schemeID = DK:CPR, ID must be a valid CPR number (like '1234560000', value found: '<xsl:text />
          <xsl:value-of select="cbc:ID" />
          <xsl:text />')</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID/@schemeID = 'GLN') and not(string-length(cbc:ID) = 13)">
      <svrl:successful-report test="(cbc:ID/@schemeID = 'GLN') and not(string-length(cbc:ID) = 13)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB185] schemeID = GLN, ID must be a valid GLN number (like '1234567890123', value found: '<xsl:text />
          <xsl:value-of select="cbc:ID" />
          <xsl:text />')</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID/@schemeID = 'EAN') and not(string-length(cbc:ID) = 13)">
      <svrl:successful-report test="(cbc:ID/@schemeID = 'EAN') and not(string-length(cbc:ID) = 13)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB218] schemeID = EAN, ID must be a valid EAN number (like '1234567890123', value found: '<xsl:text />
          <xsl:value-of select="cbc:ID" />
          <xsl:text />')</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID/@schemeID = 'DK:P') and not(string-length(cbc:ID) = 10)">
      <svrl:successful-report test="(cbc:ID/@schemeID = 'DK:P') and not(string-length(cbc:ID) = 10)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB287] schemeID = DK:P, ID must be a valid P number (like '1234567890', value found: '<xsl:text />
          <xsl:value-of select="cbc:ID" />
          <xsl:text />')</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M18" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:Signature/cac:SignatoryParty/cac:PartyName" mode="M18" priority="1012">
    <svrl:fired-rule context="doc:Reminder/cac:Signature/cac:SignatoryParty/cac:PartyName" />

		<!--REPORT -->
<xsl:if test="count(../cac:PartyName) > 1 and not(./cbc:Name/@languageID)">
      <svrl:successful-report test="count(../cac:PartyName) > 1 and not(./cbc:Name/@languageID)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[W-LIB219] The attribute Name@languageID should be used when more than one PartyName class is present</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="local-name(following-sibling::*) = local-name(current()) and following-sibling::*/cbc:Name/@languageID = self::*/cbc:Name/@languageID">
      <svrl:successful-report test="local-name(following-sibling::*) = local-name(current()) and following-sibling::*/cbc:Name/@languageID = self::*/cbc:Name/@languageID">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[W-LIB220] Multilanguage error. Replicated PartyName classes with same Name@languageID attribute value</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M18" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:Signature/cac:SignatoryParty/cac:PostalAddress" mode="M18" priority="1011">
    <svrl:fired-rule context="doc:Reminder/cac:Signature/cac:SignatoryParty/cac:PostalAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:BlockName) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:BlockName) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB210] BlockName element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:TimezoneOffset) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:TimezoneOffset) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB211] TimezoneOffset element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:LocationCoordinate) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:LocationCoordinate) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB212] LocationCoordinate class must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:AddressFormatCode) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:AddressFormatCode) != ''">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB025] Invalid AddressFormatCode. Must contain a value</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listID = 'urn:oioubl:codelist:addresstypecode-1.1')">
      <svrl:successful-report test="cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listID = 'urn:oioubl:codelist:addresstypecode-1.1')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB204] Invalid listID. Must be 'urn:oioubl:codelist:addresstypecode-1.1'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listAgencyID = '320')">
      <svrl:successful-report test="cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listAgencyID = '320')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB205] Invalid listAgencyID. Must be '320'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode = 'Home' or cbc:AddressTypeCode = 'Business' )">
      <svrl:successful-report test="cbc:AddressTypeCode and not(cbc:AddressTypeCode = 'Home' or cbc:AddressTypeCode = 'Business' )">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB206] Invalid AddressTypeCode. Must be a value from the codelist</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:AddressFormatCode/@listID = 'urn:oioubl:codelist:addressformatcode-1.1' or cbc:AddressFormatCode/@listID = 'UN/ECE 3477'" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:AddressFormatCode/@listID = 'urn:oioubl:codelist:addressformatcode-1.1' or cbc:AddressFormatCode/@listID = 'UN/ECE 3477'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB026] Invalid listID. Must be either 'urn:oioubl:codelist:addressformatcode-1.1' or 'UN/ECE 3477'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'urn:oioubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode/@listAgencyID = '320')">
      <svrl:successful-report test="cbc:AddressFormatCode/@listID = 'urn:oioubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode/@listAgencyID = '320')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB207] Invalid listAgencyID. Must be '320'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'urn:oioubl:codelist:addressformatcode-1.1' and not(normalize-space(cbc:AddressFormatCode) = 'StructuredDK' or normalize-space(cbc:AddressFormatCode) = 'StructuredLax' or normalize-space(cbc:AddressFormatCode) = 'StructuredID' or normalize-space(cbc:AddressFormatCode) = 'StructuredRegion' or normalize-space(cbc:AddressFormatCode) = 'Unstructured')">
      <svrl:successful-report test="cbc:AddressFormatCode/@listID = 'urn:oioubl:codelist:addressformatcode-1.1' and not(normalize-space(cbc:AddressFormatCode) = 'StructuredDK' or normalize-space(cbc:AddressFormatCode) = 'StructuredLax' or normalize-space(cbc:AddressFormatCode) = 'StructuredID' or normalize-space(cbc:AddressFormatCode) = 'StructuredRegion' or normalize-space(cbc:AddressFormatCode) = 'Unstructured')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB027] Invalid AddressFormatCode. Must be a value from the codelist</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode/@listAgencyID = '6')">
      <svrl:successful-report test="cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode/@listAgencyID = '6')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB208] Invalid listAgencyID. Must be '6'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode = '1' or cbc:AddressFormatCode = '2' or cbc:AddressFormatCode = '3' or cbc:AddressFormatCode = '4' or cbc:AddressFormatCode = '5' or cbc:AddressFormatCode = '6' or cbc:AddressFormatCode = '7' or cbc:AddressFormatCode = '8' or cbc:AddressFormatCode = '9')">
      <svrl:successful-report test="cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode = '1' or cbc:AddressFormatCode = '2' or cbc:AddressFormatCode = '3' or cbc:AddressFormatCode = '4' or cbc:AddressFormatCode = '5' or cbc:AddressFormatCode = '6' or cbc:AddressFormatCode = '7' or cbc:AddressFormatCode = '8' or cbc:AddressFormatCode = '9')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB209] Invalid AddressFormatCode. Must be a value from the codelist</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Country and not(cac:Country/cbc:IdentificationCode != '')">
      <svrl:successful-report test="cac:Country and not(cac:Country/cbc:IdentificationCode != '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB213] When Country is used, the element Country/IdentificationCode must be filled out</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'Unstructured') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'Unstructured') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB031] An Unstructured address is only allowed to have AddressLine elements</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and cac:AddressLine">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'StructuredDK') and cac:AddressLine">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB032] AddressLine elements not allowed for a StructuredDK address type</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and (not(cbc:PostalZone) or normalize-space(cbc:PostalZone) = '')">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'StructuredDK') and (not(cbc:PostalZone) or normalize-space(cbc:PostalZone) = '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB033] PostalZone is mandatory for a StructuredDK address type</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:StreetName) or normalize-space(cbc:StreetName) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:StreetName) or normalize-space(cbc:StreetName) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB034] There should be either a StreetName or a Postbox for a StructuredDK address type</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:BuildingNumber) or normalize-space(cbc:BuildingNumber) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:BuildingNumber) or normalize-space(cbc:BuildingNumber) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB035] There should be either a BuildingNumber or a Postbox for a StructuredDK address type</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredLax') and cac:AddressLine">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'StructuredLax') and cac:AddressLine">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB036] AddressLine elements not allowed for a StructuredLax address type</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredID') and (not(cbc:ID) or cbc:ID = '')">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'StructuredID') and (not(cbc:ID) or cbc:ID = '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB037] ID is required for a StructuredID address type</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredID') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'StructuredID') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB038] Only the ID is used for a StructuredID address type</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredRegion') and ((not(cac:Country/cbc:IdentificationCode) or cac:Country/cbc:IdentificationCode = '') and (not(cbc:Region) or cbc:Region = '') and (not(cbc:District) or cbc:District = ''))">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'StructuredRegion') and ((not(cac:Country/cbc:IdentificationCode) or cac:Country/cbc:IdentificationCode = '') and (not(cbc:Region) or cbc:Region = '') and (not(cbc:District) or cbc:District = ''))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB039] Region or District or Country/IdentificationCode is required for a StructuredRegion address type</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredRegion') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0')">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'StructuredRegion') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB040] Only Region, District, and/or Country/IdentificationCode can be used for a StructuredRegion address type</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:ID and not(string-length(cbc:ID/@schemeID)>0)">
      <svrl:successful-report test="cbc:ID and not(string-length(cbc:ID/@schemeID)>0)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB028] When ID is used under Address the attribute schemeID is used to give an addressregister</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:ID and not(cbc:ID/@schemeID)">
      <svrl:successful-report test="cbc:ID and not(cbc:ID/@schemeID)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB029] schemeID attribute must be present on an address ID</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Country/cbc:IdentificationCode and not(contains($CountryCode, concat(',',cac:Country/cbc:IdentificationCode,',')))">
      <svrl:successful-report test="cac:Country/cbc:IdentificationCode and not(contains($CountryCode, concat(',',cac:Country/cbc:IdentificationCode,',')))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB301] Invalid Country/IdentificationCode: '<xsl:text />
          <xsl:value-of select="cac:Country/cbc:IdentificationCode" />
          <xsl:text />'. Must be a value from the codelist</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M18" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:Signature/cac:SignatoryParty/cac:PhysicalLocation" mode="M18" priority="1010">
    <svrl:fired-rule context="doc:Reminder/cac:Signature/cac:SignatoryParty/cac:PhysicalLocation" />

		<!--REPORT -->
<xsl:if test="(not(cbc:ID) or cbc:ID = '') and (count(cac:Address) = 0)">
      <svrl:successful-report test="(not(cbc:ID) or cbc:ID = '') and (count(cac:Address) = 0)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB221] If ID not specified, Address is mandatory</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M18" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:Signature/cac:SignatoryParty/cac:PhysicalLocation/cac:ValidityPeriod" mode="M18" priority="1009">
    <svrl:fired-rule context="doc:Reminder/cac:Signature/cac:SignatoryParty/cac:PhysicalLocation/cac:ValidityPeriod" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:DurationMeasure) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:DurationMeasure) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB076] DurationMeasure element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:DescriptionCode) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:DescriptionCode) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB077] DescriptionCode element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:StartTime) and (not(cbc:StartDate) or cbc:StartDate = '')">
      <svrl:successful-report test="(cbc:StartTime) and (not(cbc:StartDate) or cbc:StartDate = '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB078] There must be a StartDate if you have a StartTime</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:EndTime) and (not(cbc:EndDate) or cbc:EndDate = '')">
      <svrl:successful-report test="(cbc:EndTime) and (not(cbc:EndDate) or cbc:EndDate = '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB079] There must be a EndDate if you have a EndTime</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:StartDate and cbc:EndDate) and not(number(translate(cbc:EndDate,'-','')) > number(translate(cbc:StartDate,'-','')) or number(translate(cbc:EndDate,'-','')) = number(translate(cbc:StartDate,'-','')))">
      <svrl:successful-report test="(cbc:StartDate and cbc:EndDate) and not(number(translate(cbc:EndDate,'-','')) > number(translate(cbc:StartDate,'-','')) or number(translate(cbc:EndDate,'-','')) = number(translate(cbc:StartDate,'-','')))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB080] The EndDate must be greater or equal to the startdate</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:StartTime and cbc:EndTime) and not(number(translate(cbc:EndTime,':','')) > number(translate(cbc:StartTime,':','')) or number(translate(cbc:EndTime,':','')) = number(translate(cbc:StartTime,':','')))">
      <svrl:successful-report test="(cbc:StartTime and cbc:EndTime) and not(number(translate(cbc:EndTime,':','')) > number(translate(cbc:StartTime,':','')) or number(translate(cbc:EndTime,':','')) = number(translate(cbc:StartTime,':','')))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB081] EndTime must be greater or equal to StartTime</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M18" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:Signature/cac:SignatoryParty/cac:PhysicalLocation/cac:ValidityPeriod/cbc:Description" mode="M18" priority="1008">
    <svrl:fired-rule context="doc:Reminder/cac:Signature/cac:SignatoryParty/cac:PhysicalLocation/cac:ValidityPeriod/cbc:Description" />

		<!--REPORT -->
<xsl:if test="count(../cbc:Description) > 1 and not(./@languageID)">
      <svrl:successful-report test="count(../cbc:Description) > 1 and not(./@languageID)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[W-LIB222] The attribute languageID should be used when more than one Description element is present</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID">
      <svrl:successful-report test="local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[W-LIB223] Multilanguage error. Replicated Description elements with same languageID attribute value</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M18" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:Signature/cac:SignatoryParty/cac:PhysicalLocation/cac:Address" mode="M18" priority="1007">
    <svrl:fired-rule context="doc:Reminder/cac:Signature/cac:SignatoryParty/cac:PhysicalLocation/cac:Address" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:BlockName) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:BlockName) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB210] BlockName element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:TimezoneOffset) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:TimezoneOffset) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB211] TimezoneOffset element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:LocationCoordinate) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:LocationCoordinate) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB212] LocationCoordinate class must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:AddressFormatCode) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:AddressFormatCode) != ''">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB025] Invalid AddressFormatCode. Must contain a value</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listID = 'urn:oioubl:codelist:addresstypecode-1.1')">
      <svrl:successful-report test="cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listID = 'urn:oioubl:codelist:addresstypecode-1.1')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB204] Invalid listID. Must be 'urn:oioubl:codelist:addresstypecode-1.1'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listAgencyID = '320')">
      <svrl:successful-report test="cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listAgencyID = '320')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB205] Invalid listAgencyID. Must be '320'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode = 'Home' or cbc:AddressTypeCode = 'Business' )">
      <svrl:successful-report test="cbc:AddressTypeCode and not(cbc:AddressTypeCode = 'Home' or cbc:AddressTypeCode = 'Business' )">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB206] Invalid AddressTypeCode. Must be a value from the codelist</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:AddressFormatCode/@listID = 'urn:oioubl:codelist:addressformatcode-1.1' or cbc:AddressFormatCode/@listID = 'UN/ECE 3477'" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:AddressFormatCode/@listID = 'urn:oioubl:codelist:addressformatcode-1.1' or cbc:AddressFormatCode/@listID = 'UN/ECE 3477'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB026] Invalid listID. Must be either 'urn:oioubl:codelist:addressformatcode-1.1' or 'UN/ECE 3477'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'urn:oioubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode/@listAgencyID = '320')">
      <svrl:successful-report test="cbc:AddressFormatCode/@listID = 'urn:oioubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode/@listAgencyID = '320')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB207] Invalid listAgencyID. Must be '320'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'urn:oioubl:codelist:addressformatcode-1.1' and not(normalize-space(cbc:AddressFormatCode) = 'StructuredDK' or normalize-space(cbc:AddressFormatCode) = 'StructuredLax' or normalize-space(cbc:AddressFormatCode) = 'StructuredID' or normalize-space(cbc:AddressFormatCode) = 'StructuredRegion' or normalize-space(cbc:AddressFormatCode) = 'Unstructured')">
      <svrl:successful-report test="cbc:AddressFormatCode/@listID = 'urn:oioubl:codelist:addressformatcode-1.1' and not(normalize-space(cbc:AddressFormatCode) = 'StructuredDK' or normalize-space(cbc:AddressFormatCode) = 'StructuredLax' or normalize-space(cbc:AddressFormatCode) = 'StructuredID' or normalize-space(cbc:AddressFormatCode) = 'StructuredRegion' or normalize-space(cbc:AddressFormatCode) = 'Unstructured')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB027] Invalid AddressFormatCode. Must be a value from the codelist</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode/@listAgencyID = '6')">
      <svrl:successful-report test="cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode/@listAgencyID = '6')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB208] Invalid listAgencyID. Must be '6'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode = '1' or cbc:AddressFormatCode = '2' or cbc:AddressFormatCode = '3' or cbc:AddressFormatCode = '4' or cbc:AddressFormatCode = '5' or cbc:AddressFormatCode = '6' or cbc:AddressFormatCode = '7' or cbc:AddressFormatCode = '8' or cbc:AddressFormatCode = '9')">
      <svrl:successful-report test="cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode = '1' or cbc:AddressFormatCode = '2' or cbc:AddressFormatCode = '3' or cbc:AddressFormatCode = '4' or cbc:AddressFormatCode = '5' or cbc:AddressFormatCode = '6' or cbc:AddressFormatCode = '7' or cbc:AddressFormatCode = '8' or cbc:AddressFormatCode = '9')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB209] Invalid AddressFormatCode. Must be a value from the codelist</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Country and not(cac:Country/cbc:IdentificationCode != '')">
      <svrl:successful-report test="cac:Country and not(cac:Country/cbc:IdentificationCode != '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB213] When Country is used, the element Country/IdentificationCode must be filled out</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'Unstructured') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'Unstructured') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB031] An Unstructured address is only allowed to have AddressLine elements</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and cac:AddressLine">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'StructuredDK') and cac:AddressLine">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB032] AddressLine elements not allowed for a StructuredDK address type</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and (not(cbc:PostalZone) or normalize-space(cbc:PostalZone) = '')">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'StructuredDK') and (not(cbc:PostalZone) or normalize-space(cbc:PostalZone) = '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB033] PostalZone is mandatory for a StructuredDK address type</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:StreetName) or normalize-space(cbc:StreetName) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:StreetName) or normalize-space(cbc:StreetName) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB034] There should be either a StreetName or a Postbox for a StructuredDK address type</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:BuildingNumber) or normalize-space(cbc:BuildingNumber) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:BuildingNumber) or normalize-space(cbc:BuildingNumber) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB035] There should be either a BuildingNumber or a Postbox for a StructuredDK address type</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredLax') and cac:AddressLine">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'StructuredLax') and cac:AddressLine">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB036] AddressLine elements not allowed for a StructuredLax address type</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredID') and (not(cbc:ID) or cbc:ID = '')">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'StructuredID') and (not(cbc:ID) or cbc:ID = '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB037] ID is required for a StructuredID address type</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredID') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'StructuredID') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB038] Only the ID is used for a StructuredID address type</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredRegion') and ((not(cac:Country/cbc:IdentificationCode) or cac:Country/cbc:IdentificationCode = '') and (not(cbc:Region) or cbc:Region = '') and (not(cbc:District) or cbc:District = ''))">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'StructuredRegion') and ((not(cac:Country/cbc:IdentificationCode) or cac:Country/cbc:IdentificationCode = '') and (not(cbc:Region) or cbc:Region = '') and (not(cbc:District) or cbc:District = ''))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB039] Region or District or Country/IdentificationCode is required for a StructuredRegion address type</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredRegion') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0')">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'StructuredRegion') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB040] Only Region, District, and/or Country/IdentificationCode can be used for a StructuredRegion address type</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:ID and not(string-length(cbc:ID/@schemeID)>0)">
      <svrl:successful-report test="cbc:ID and not(string-length(cbc:ID/@schemeID)>0)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB028] When ID is used under Address the attribute schemeID is used to give an addressregister</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:ID and not(cbc:ID/@schemeID)">
      <svrl:successful-report test="cbc:ID and not(cbc:ID/@schemeID)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB029] schemeID attribute must be present on an address ID</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Country/cbc:IdentificationCode and not(contains($CountryCode, concat(',',cac:Country/cbc:IdentificationCode,',')))">
      <svrl:successful-report test="cac:Country/cbc:IdentificationCode and not(contains($CountryCode, concat(',',cac:Country/cbc:IdentificationCode,',')))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB301] Invalid Country/IdentificationCode: '<xsl:text />
          <xsl:value-of select="cac:Country/cbc:IdentificationCode" />
          <xsl:text />'. Must be a value from the codelist</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M18" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:Signature/cac:SignatoryParty/cac:PartyTaxScheme" mode="M18" priority="1006">
    <svrl:fired-rule context="doc:Reminder/cac:Signature/cac:SignatoryParty/cac:PartyTaxScheme" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:TaxLevelCode) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:TaxLevelCode) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB192] TaxLevelCode element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:CompanyID) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:CompanyID) != ''">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB193] Invalid CompanyID. Must contain a value</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:CompanyID/@schemeID = 'DK:SE' or cbc:CompanyID/@schemeID = 'ZZZ' " />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:CompanyID/@schemeID = 'DK:SE' or cbc:CompanyID/@schemeID = 'ZZZ'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB195] Invalid schemeID. Must be a valid scheme for PartyTaxScheme/CompanyID</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:CompanyID/@schemeID = 'DK:SE') and (string-length(normalize-space(cbc:CompanyID)) != 10 or substring(cbc:CompanyID, 1, 2) != 'DK')">
      <svrl:successful-report test="(cbc:CompanyID/@schemeID = 'DK:SE') and (string-length(normalize-space(cbc:CompanyID)) != 10 or substring(cbc:CompanyID, 1, 2) != 'DK')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB196] schemeID = DK:SE, CompanyID must be a valid SE number (like 'DK12345678', value found: '<xsl:text />
          <xsl:value-of select="cbc:CompanyID" />
          <xsl:text />')</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M18" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:Signature/cac:SignatoryParty/cac:PartyTaxScheme/cac:TaxScheme" mode="M18" priority="1005">
    <svrl:fired-rule context="doc:Reminder/cac:Signature/cac:SignatoryParty/cac:PartyTaxScheme/cac:TaxScheme" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:ID) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:ID) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB041] ID element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:AddressTypeCode) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:AddressTypeCode) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB042] AddressTypeCode element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:Postbox) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:Postbox) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB043] Postbox element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:Floor) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:Floor) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB044] Floor element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:Room) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:Room) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB045] Room element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:StreetName) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:StreetName) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB046] StreetName element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:AdditionalStreetName) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:AdditionalStreetName) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB047] AdditionalStreetName element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:BlockName) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:BlockName) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB048] BlockName element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:BuildingName) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:BuildingName) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB049] BuildingName element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:BuildingNumber) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:BuildingNumber) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB050] BuildingNumber element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:InhouseMail) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:InhouseMail) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB051] InhouseMail element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:Department) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:Department) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB052] Department element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:MarkAttention) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:MarkAttention) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB053] MarkAttention element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:MarkCare) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:MarkCare) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB054] MarkCare element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:PlotIdentification) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:PlotIdentification) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB055] PlotIdentification element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:CitySubdivisionName) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:CitySubdivisionName) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB056] CitySubdivisionName element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:CityName) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:CityName) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB057] CityName element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:PostalZone) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:PostalZone) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB058] PostalZone element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:CountrySubentity) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:CountrySubentity) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB059] CountrySubentity element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:CountrySubentityCode) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:CountrySubentityCode) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB060] CountrySubentityCode element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:TimezoneOffset) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:TimezoneOffset) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB063] TimezoneOffset element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cac:AddressLine) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cac:AddressLine) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB234] AddressLine class must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cac:LocationCoordinate) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cac:LocationCoordinate) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB064] LocationCoordinate class must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:ID = '63') and cbc:TaxTypeCode">
      <svrl:successful-report test="(cbc:ID = '63') and cbc:TaxTypeCode">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB067] TaxTypeCode is not allowed when TaxScheme/ID equals '63' (Moms)</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:ID) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:ID) != ''">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB065] Invalid TaxScheme/ID. Must contain a value.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:Name) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:Name) != ''">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB066] Invalid Name. Must contain a value</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="not((cbc:ID = '63' or cbc:ID = 'VAT')) and not(contains($TaxType2, concat(',',cbc:TaxTypeCode,',')))">
      <svrl:successful-report test="not((cbc:ID = '63' or cbc:ID = 'VAT')) and not(contains($TaxType2, concat(',',cbc:TaxTypeCode,',')))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB197] TaxTypeCode must be a value from the '<xsl:text />
          <xsl:value-of select="$TaxType_listID2" />
          <xsl:text />' codelist when TaxScheme/ID is different from '63' or 'VAT' (Moms)</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID/@schemeID = $TaxScheme_schemeID or cbc:ID/@schemeID = $TaxScheme2_schemeID or cbc:ID/@schemeID = $TaxScheme4_schemeID or cbc:ID/@schemeID = $TaxScheme5_schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID/@schemeID = $TaxScheme_schemeID or cbc:ID/@schemeID = $TaxScheme2_schemeID or cbc:ID/@schemeID = $TaxScheme4_schemeID or cbc:ID/@schemeID = $TaxScheme5_schemeID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB070] Invalid schemeID. Must be either '<xsl:text />
            <xsl:value-of select="$TaxScheme_schemeID" />
            <xsl:text />', '<xsl:text />
            <xsl:value-of select="$TaxScheme2_schemeID" />
            <xsl:text />', '<xsl:text />
            <xsl:value-of select="$TaxScheme4_schemeID" />
            <xsl:text />' or '<xsl:text />
            <xsl:value-of select="$TaxScheme5_schemeID" />
            <xsl:text />'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:TaxTypeCode) and not((cbc:TaxTypeCode/@listID = $TaxType_listID) or (cbc:TaxTypeCode/@listID = $TaxType_listID2))">
      <svrl:successful-report test="(cbc:TaxTypeCode) and not((cbc:TaxTypeCode/@listID = $TaxType_listID) or (cbc:TaxTypeCode/@listID = $TaxType_listID2))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB071] Invalid listID. Must be either '<xsl:text />
          <xsl:value-of select="$TaxType_listID" />
          <xsl:text />' or '<xsl:text />
          <xsl:value-of select="$TaxType_listID2" />
          <xsl:text />'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID = '63') and cbc:Name != 'Moms'">
      <svrl:successful-report test="(cbc:ID = '63') and cbc:Name != 'Moms'">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB198] Name must equal 'Moms' when TaxScheme/ID equals '63' (Moms)</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID != '63') and cbc:Name = 'Moms'">
      <svrl:successful-report test="(cbc:ID != '63') and cbc:Name = 'Moms'">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB199] Name must correspond to the value of TaxScheme/ID</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cac:JurisdictionRegionAddress/cac:Country/cbc:IdentificationCode) and not(contains($CountryCode, concat(',',cac:JurisdictionRegionAddress/cac:Country/cbc:IdentificationCode,',')))">
      <svrl:successful-report test="(cac:JurisdictionRegionAddress/cac:Country/cbc:IdentificationCode) and not(contains($CountryCode, concat(',',cac:JurisdictionRegionAddress/cac:Country/cbc:IdentificationCode,',')))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB337] Invalid Country/IdentificationCode: '<xsl:text />
          <xsl:value-of select="cac:JurisdictionRegionAddress/cac:Country/cbc:IdentificationCode" />
          <xsl:text />'. Must be a value from the country codelist</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cac:JurisdictionRegionAddress) and cac:JurisdictionRegionAddress/cbc:AddressFormatCode != 'StructuredRegion'">
      <svrl:successful-report test="(cac:JurisdictionRegionAddress) and cac:JurisdictionRegionAddress/cbc:AddressFormatCode != 'StructuredRegion'">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB233] The AddressFormatCode under JurisdictionRegionAddress must always equal 'StructuredRegion'</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M18" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:Signature/cac:SignatoryParty/cac:PartyLegalEntity" mode="M18" priority="1004">
    <svrl:fired-rule context="doc:Reminder/cac:Signature/cac:SignatoryParty/cac:PartyLegalEntity" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:CorporateRegistrationScheme) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:CorporateRegistrationScheme) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB186] CorporateRegistrationScheme class must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:CompanyID) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:CompanyID) != ''">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB187] Invalid CompanyID. Must contain a value</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:CompanyID/@schemeID = 'DK:CVR' or cbc:CompanyID/@schemeID = 'DK:CPR' or cbc:CompanyID/@schemeID = 'ZZZ'" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:CompanyID/@schemeID = 'DK:CVR' or cbc:CompanyID/@schemeID = 'DK:CPR' or cbc:CompanyID/@schemeID = 'ZZZ'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB189] Invalid schemeID. Must be a valid scheme for PartyLegalEntity/CompanyID</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:CompanyID/@schemeID = 'DK:CVR') and (string-length(normalize-space(cbc:CompanyID)) != 10 or substring(cbc:CompanyID, 1, 2) != 'DK')">
      <svrl:successful-report test="(cbc:CompanyID/@schemeID = 'DK:CVR') and (string-length(normalize-space(cbc:CompanyID)) != 10 or substring(cbc:CompanyID, 1, 2) != 'DK')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB190] schemeID = DK:CVR, CompanyID must be a valid CVR number (like 'DK12345678', value found: '<xsl:text />
          <xsl:value-of select="cbc:CompanyID" />
          <xsl:text />')</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:CompanyID/@schemeID = 'DK:CPR') and not(string-length(cbc:CompanyID) = 10)">
      <svrl:successful-report test="(cbc:CompanyID/@schemeID = 'DK:CPR') and not(string-length(cbc:CompanyID) = 10)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB191] schemeID = DK:CPR, CompanyID must be a valid CPR number (like '1234560000', value found: '<xsl:text />
          <xsl:value-of select="cbc:CompanyID" />
          <xsl:text />')</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M18" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:Signature/cac:SignatoryParty/cac:Contact" mode="M18" priority="1003">
    <svrl:fired-rule context="doc:Reminder/cac:Signature/cac:SignatoryParty/cac:Contact" />

		<!--REPORT -->
<xsl:if test="(not(cbc:ID) or cbc:ID = '') and (not(cbc:Name) or cbc:Name = '') and (not(cbc:Telephone) or cbc:Telephone = '') and (not(cbc:Telefax) or cbc:Telefax = '') and (not(cbc:ElectronicMail) or cbc:ElectronicMail = '') and (not(cbc:Note) or cbc:Note = '') and not(cac:OtherCommunication)">
      <svrl:successful-report test="(not(cbc:ID) or cbc:ID = '') and (not(cbc:Name) or cbc:Name = '') and (not(cbc:Telephone) or cbc:Telephone = '') and (not(cbc:Telefax) or cbc:Telefax = '') and (not(cbc:ElectronicMail) or cbc:ElectronicMail = '') and (not(cbc:Note) or cbc:Note = '') and not(cac:OtherCommunication)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB235] At least one field in the Contact class should be specified</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:OtherCommunication/cbc:ChannelCode and cac:OtherCommunication/cbc:Channel">
      <svrl:successful-report test="cac:OtherCommunication/cbc:ChannelCode and cac:OtherCommunication/cbc:Channel">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB236] Use either ChannelCode or Channel</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:OtherCommunication and (normalize-space(cac:OtherCommunication/cbc:Value) = '')">
      <svrl:successful-report test="cac:OtherCommunication and (normalize-space(cac:OtherCommunication/cbc:Value) = '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB237] When Contact/OtherCommunication is used, the element Contact/OtherCommunication/Value must be filled out.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M18" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:Signature/cac:SignatoryParty/cac:Person" mode="M18" priority="1002">
    <svrl:fired-rule context="doc:Reminder/cac:Signature/cac:SignatoryParty/cac:Person" />

		<!--REPORT -->
<xsl:if test="(not(cbc:FamilyName) or cbc:FamilyName = '') and (not(cbc:FirstName) or cbc:FirstName = '')">
      <svrl:successful-report test="(not(cbc:FamilyName) or cbc:FamilyName = '') and (not(cbc:FirstName) or cbc:FirstName = '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB024] There must be a FirstName if the FamilyName is not present</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M18" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:Signature/cac:DigitalSignatureAttachment" mode="M18" priority="1001">
    <svrl:fired-rule context="doc:Reminder/cac:Signature/cac:DigitalSignatureAttachment" />

		<!--REPORT -->
<xsl:if test="cbc:EmbeddedDocumentBinaryObject and cac:ExternalReference">
      <svrl:successful-report test="cbc:EmbeddedDocumentBinaryObject and cac:ExternalReference">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB284] Use either EmbeddedDocumentBinaryObject or ExternalReference</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:EmbeddedDocumentBinaryObject and not(cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/tiff' or cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/png' or cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/jpeg' or cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/gif' or cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/pdf' or cbc:EmbeddedDocumentBinaryObject/@mimeCode='text/xml' or cbc:EmbeddedDocumentBinaryObject/@mimeCode='text/csv' or cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.ms-excel' or cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' or cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.oasis.opendocument.spreadsheet')">
      <svrl:successful-report test="cbc:EmbeddedDocumentBinaryObject and not(cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/tiff' or cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/png' or cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/jpeg' or cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/gif' or cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/pdf' or cbc:EmbeddedDocumentBinaryObject/@mimeCode='text/xml' or cbc:EmbeddedDocumentBinaryObject/@mimeCode='text/csv' or cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.ms-excel' or cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' or cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.oasis.opendocument.spreadsheet')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB285] Attribute mimeCode must be a value from the codelist</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:ExternalReference and not(cac:ExternalReference/cbc:URI != '')">
      <svrl:successful-report test="cac:ExternalReference and not(cac:ExternalReference/cbc:URI != '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB286] When using ExternalReference, URI is mandatory</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M18" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:Signature/cac:OriginalDocumentReference" mode="M18" priority="1000">
    <svrl:fired-rule context="doc:Reminder/cac:Signature/cac:OriginalDocumentReference" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:DocumentType or cbc:DocumentTypeCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:DocumentType or cbc:DocumentTypeCode">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB092] Use either DocumentType or DocumentTypeCode</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="cac:Attachment and cbc:XPath">
      <svrl:successful-report test="cac:Attachment and cbc:XPath">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB093] Use either Attachment or XPath</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Attachment/cbc:EmbeddedDocumentBinaryObject and cac:Attachment/cac:ExternalReference">
      <svrl:successful-report test="cac:Attachment/cbc:EmbeddedDocumentBinaryObject and cac:Attachment/cac:ExternalReference">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB095] Use either EmbeddedDocumentBinaryObject or ExternalReference</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:UUID and not(string-length(string(cbc:UUID)) = 36)">
      <svrl:successful-report test="cbc:UUID and not(string-length(string(cbc:UUID)) = 36)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB097] Invalid UUID. Must be of this form '6E09886B-DC6E-439F-82D1-7CCAC7F4E3B1'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Attachment/cbc:EmbeddedDocumentBinaryObject and not(cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/tiff' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/png' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/jpeg' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/gif' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/pdf' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='text/xml' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='text/csv' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.ms-excel' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.oasis.opendocument.spreadsheet')">
      <svrl:successful-report test="cac:Attachment/cbc:EmbeddedDocumentBinaryObject and not(cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/tiff' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/png' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/jpeg' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/gif' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/pdf' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='text/xml' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='text/csv' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.ms-excel' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.oasis.opendocument.spreadsheet')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB098] Attribute mimeCode must be a value from the codelist</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Attachment/cac:ExternalReference and not(cac:Attachment/cac:ExternalReference/cbc:URI != '')">
      <svrl:successful-report test="cac:Attachment/cac:ExternalReference and not(cac:Attachment/cac:ExternalReference/cbc:URI != '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB279] When using ExternalReference, URI is mandatory</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:DocumentTypeCode = 'PersonalSecure') and not (contains($PersonalSecure, concat(',',cbc:ID,',')))">
      <svrl:successful-report test="(cbc:DocumentTypeCode = 'PersonalSecure') and not (contains($PersonalSecure, concat(',',cbc:ID,',')))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB335] When DocumentTypeCode equals 'PersonalSecure', the ID must be either '1' or '2'.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M18" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M18" priority="-1" />
  <xsl:template match="@*|node()" mode="M18" priority="-2">
    <xsl:apply-templates mode="M18" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN accountingsupplierparty-->


	<!--RULE -->
<xsl:template match="doc:Reminder/cac:AccountingSupplierParty" mode="M19" priority="1016">
    <svrl:fired-rule context="doc:Reminder/cac:AccountingSupplierParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:DataSendingCapability) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:DataSendingCapability) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-REM016] DataSendingCapability element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:Party) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:Party) = 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-REM017] Party class must be present</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:AccountingSupplierParty/cac:Party" mode="M19" priority="1015">
    <svrl:fired-rule context="doc:Reminder/cac:AccountingSupplierParty/cac:Party" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:MarkCareIndicator) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:MarkCareIndicator) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB166] MarkCareIndicator element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:MarkAttentionIndicator) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:MarkAttentionIndicator) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB167] MarkAttentionIndicator element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:AgentParty) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:AgentParty) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB168] AgentParty class must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:EndpointID) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:EndpointID) != ''">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-REM018] Invalid EndpointID. Must contain a value</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:PartyLegalEntity) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:PartyLegalEntity) = 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-REM021] One PartyLegalEntity class must be present</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="(not(cac:PartyIdentification) or cac:PartyIdentification/cbc:ID = '') and (not(cac:PartyName) or cac:PartyName/cbc:Name = '')">
      <svrl:successful-report test="(not(cac:PartyIdentification) or cac:PartyIdentification/cbc:ID = '') and (not(cac:PartyName) or cac:PartyName/cbc:Name = '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB022] PartyName/Name is mandatory if PartyIdentification/ID is not found</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:EndpointID and not(contains($EndpointID_schemeID, concat(',',cbc:EndpointID/@schemeID,',')))">
      <svrl:successful-report test="cbc:EndpointID and not(contains($EndpointID_schemeID, concat(',',cbc:EndpointID/@schemeID,',')))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB179] Invalid schemeID: '<xsl:text />
          <xsl:value-of select="cbc:EndpointID/@schemeID" />
          <xsl:text />'. Must be a value from the codelist: '<xsl:text />
          <xsl:value-of select="$EndpointID_schemeID" />
          <xsl:text />'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:EndpointID/@schemeID = 'DK:CVR') and (string-length(cbc:EndpointID) != 10 or substring(cbc:EndpointID, 1, 2) != 'DK')">
      <svrl:successful-report test="(cbc:EndpointID/@schemeID = 'DK:CVR') and (string-length(cbc:EndpointID) != 10 or substring(cbc:EndpointID, 1, 2) != 'DK')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB180] schemeID = DK:CVR, EndpointID must be a valid CVR number (like 'DK12345678', value found: '<xsl:text />
          <xsl:value-of select="cbc:EndpointID" />
          <xsl:text />')</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:EndpointID/@schemeID = 'DK:CPR') and not(string-length(cbc:EndpointID) = 10)">
      <svrl:successful-report test="(cbc:EndpointID/@schemeID = 'DK:CPR') and not(string-length(cbc:EndpointID) = 10)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB215] schemeID = DK:CPR, EndpointID must be a valid CPR number (like '1234560000', value found: '<xsl:text />
          <xsl:value-of select="cbc:EndpointID" />
          <xsl:text />')</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:EndpointID/@schemeID = 'GLN') and not(string-length(cbc:EndpointID) = 13)">
      <svrl:successful-report test="(cbc:EndpointID/@schemeID = 'GLN') and not(string-length(cbc:EndpointID) = 13)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB181] schemeID = GLN, EndpointID must be a valid GLN number (like '1234567890123', value found: '<xsl:text />
          <xsl:value-of select="cbc:EndpointID" />
          <xsl:text />')</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:EndpointID/@schemeID = 'EAN') and not(string-length(cbc:EndpointID) = 13)">
      <svrl:successful-report test="(cbc:EndpointID/@schemeID = 'EAN') and not(string-length(cbc:EndpointID) = 13)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB216] schemeID = EAN, EndpointID must be a valid EAN number (like '1234567890123', value found: '<xsl:text />
          <xsl:value-of select="cbc:EndpointID" />
          <xsl:text />')</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification" mode="M19" priority="1014">
    <svrl:fired-rule context="doc:Reminder/cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification" />

		<!--REPORT -->
<xsl:if test="not(contains($PartyID_schemeID, concat(',',cbc:ID/@schemeID,',')))">
      <svrl:successful-report test="not(contains($PartyID_schemeID, concat(',',cbc:ID/@schemeID,',')))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB183] Invalid schemeID: '<xsl:text />
          <xsl:value-of select="cbc:ID/@schemeID" />
          <xsl:text />'. Must be a value from the codelist: '<xsl:text />
          <xsl:value-of select="$PartyID_schemeID" />
          <xsl:text />'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID/@schemeID = 'DK:CVR') and (string-length(cbc:ID) != 10 or substring(cbc:ID, 1, 2) != 'DK')">
      <svrl:successful-report test="(cbc:ID/@schemeID = 'DK:CVR') and (string-length(cbc:ID) != 10 or substring(cbc:ID, 1, 2) != 'DK')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB184] schemeID = DK:CVR, ID must be a valid CVR number (like 'DK12345678', value found: '<xsl:text />
          <xsl:value-of select="cbc:ID" />
          <xsl:text />')</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID/@schemeID = 'DK:CPR') and not(string-length(cbc:ID) = 10)">
      <svrl:successful-report test="(cbc:ID/@schemeID = 'DK:CPR') and not(string-length(cbc:ID) = 10)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB217] schemeID = DK:CPR, ID must be a valid CPR number (like '1234560000', value found: '<xsl:text />
          <xsl:value-of select="cbc:ID" />
          <xsl:text />')</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID/@schemeID = 'GLN') and not(string-length(cbc:ID) = 13)">
      <svrl:successful-report test="(cbc:ID/@schemeID = 'GLN') and not(string-length(cbc:ID) = 13)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB185] schemeID = GLN, ID must be a valid GLN number (like '1234567890123', value found: '<xsl:text />
          <xsl:value-of select="cbc:ID" />
          <xsl:text />')</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID/@schemeID = 'EAN') and not(string-length(cbc:ID) = 13)">
      <svrl:successful-report test="(cbc:ID/@schemeID = 'EAN') and not(string-length(cbc:ID) = 13)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB218] schemeID = EAN, ID must be a valid EAN number (like '1234567890123', value found: '<xsl:text />
          <xsl:value-of select="cbc:ID" />
          <xsl:text />')</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID/@schemeID = 'DK:P') and not(string-length(cbc:ID) = 10)">
      <svrl:successful-report test="(cbc:ID/@schemeID = 'DK:P') and not(string-length(cbc:ID) = 10)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB287] schemeID = DK:P, ID must be a valid P number (like '1234567890', value found: '<xsl:text />
          <xsl:value-of select="cbc:ID" />
          <xsl:text />')</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:AccountingSupplierParty/cac:Party/cac:PartyName" mode="M19" priority="1013">
    <svrl:fired-rule context="doc:Reminder/cac:AccountingSupplierParty/cac:Party/cac:PartyName" />

		<!--REPORT -->
<xsl:if test="count(../cac:PartyName) > 1 and not(./cbc:Name/@languageID)">
      <svrl:successful-report test="count(../cac:PartyName) > 1 and not(./cbc:Name/@languageID)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[W-LIB219] The attribute Name@languageID should be used when more than one PartyName class is present</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="local-name(following-sibling::*) = local-name(current()) and following-sibling::*/cbc:Name/@languageID = self::*/cbc:Name/@languageID">
      <svrl:successful-report test="local-name(following-sibling::*) = local-name(current()) and following-sibling::*/cbc:Name/@languageID = self::*/cbc:Name/@languageID">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[W-LIB220] Multilanguage error. Replicated PartyName classes with same Name@languageID attribute value</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress" mode="M19" priority="1012">
    <svrl:fired-rule context="doc:Reminder/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:BlockName) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:BlockName) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB210] BlockName element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:TimezoneOffset) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:TimezoneOffset) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB211] TimezoneOffset element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:LocationCoordinate) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:LocationCoordinate) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB212] LocationCoordinate class must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:AddressFormatCode) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:AddressFormatCode) != ''">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB025] Invalid AddressFormatCode. Must contain a value</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listID = 'urn:oioubl:codelist:addresstypecode-1.1')">
      <svrl:successful-report test="cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listID = 'urn:oioubl:codelist:addresstypecode-1.1')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB204] Invalid listID. Must be 'urn:oioubl:codelist:addresstypecode-1.1'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listAgencyID = '320')">
      <svrl:successful-report test="cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listAgencyID = '320')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB205] Invalid listAgencyID. Must be '320'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode = 'Home' or cbc:AddressTypeCode = 'Business' )">
      <svrl:successful-report test="cbc:AddressTypeCode and not(cbc:AddressTypeCode = 'Home' or cbc:AddressTypeCode = 'Business' )">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB206] Invalid AddressTypeCode. Must be a value from the codelist</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:AddressFormatCode/@listID = 'urn:oioubl:codelist:addressformatcode-1.1' or cbc:AddressFormatCode/@listID = 'UN/ECE 3477'" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:AddressFormatCode/@listID = 'urn:oioubl:codelist:addressformatcode-1.1' or cbc:AddressFormatCode/@listID = 'UN/ECE 3477'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB026] Invalid listID. Must be either 'urn:oioubl:codelist:addressformatcode-1.1' or 'UN/ECE 3477'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'urn:oioubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode/@listAgencyID = '320')">
      <svrl:successful-report test="cbc:AddressFormatCode/@listID = 'urn:oioubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode/@listAgencyID = '320')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB207] Invalid listAgencyID. Must be '320'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'urn:oioubl:codelist:addressformatcode-1.1' and not(normalize-space(cbc:AddressFormatCode) = 'StructuredDK' or normalize-space(cbc:AddressFormatCode) = 'StructuredLax' or normalize-space(cbc:AddressFormatCode) = 'StructuredID' or normalize-space(cbc:AddressFormatCode) = 'StructuredRegion' or normalize-space(cbc:AddressFormatCode) = 'Unstructured')">
      <svrl:successful-report test="cbc:AddressFormatCode/@listID = 'urn:oioubl:codelist:addressformatcode-1.1' and not(normalize-space(cbc:AddressFormatCode) = 'StructuredDK' or normalize-space(cbc:AddressFormatCode) = 'StructuredLax' or normalize-space(cbc:AddressFormatCode) = 'StructuredID' or normalize-space(cbc:AddressFormatCode) = 'StructuredRegion' or normalize-space(cbc:AddressFormatCode) = 'Unstructured')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB027] Invalid AddressFormatCode. Must be a value from the codelist</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode/@listAgencyID = '6')">
      <svrl:successful-report test="cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode/@listAgencyID = '6')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB208] Invalid listAgencyID. Must be '6'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode = '1' or cbc:AddressFormatCode = '2' or cbc:AddressFormatCode = '3' or cbc:AddressFormatCode = '4' or cbc:AddressFormatCode = '5' or cbc:AddressFormatCode = '6' or cbc:AddressFormatCode = '7' or cbc:AddressFormatCode = '8' or cbc:AddressFormatCode = '9')">
      <svrl:successful-report test="cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode = '1' or cbc:AddressFormatCode = '2' or cbc:AddressFormatCode = '3' or cbc:AddressFormatCode = '4' or cbc:AddressFormatCode = '5' or cbc:AddressFormatCode = '6' or cbc:AddressFormatCode = '7' or cbc:AddressFormatCode = '8' or cbc:AddressFormatCode = '9')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB209] Invalid AddressFormatCode. Must be a value from the codelist</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Country and not(cac:Country/cbc:IdentificationCode != '')">
      <svrl:successful-report test="cac:Country and not(cac:Country/cbc:IdentificationCode != '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB213] When Country is used, the element Country/IdentificationCode must be filled out</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'Unstructured') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'Unstructured') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB031] An Unstructured address is only allowed to have AddressLine elements</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and cac:AddressLine">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'StructuredDK') and cac:AddressLine">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB032] AddressLine elements not allowed for a StructuredDK address type</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and (not(cbc:PostalZone) or normalize-space(cbc:PostalZone) = '')">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'StructuredDK') and (not(cbc:PostalZone) or normalize-space(cbc:PostalZone) = '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB033] PostalZone is mandatory for a StructuredDK address type</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:StreetName) or normalize-space(cbc:StreetName) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:StreetName) or normalize-space(cbc:StreetName) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB034] There should be either a StreetName or a Postbox for a StructuredDK address type</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:BuildingNumber) or normalize-space(cbc:BuildingNumber) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:BuildingNumber) or normalize-space(cbc:BuildingNumber) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB035] There should be either a BuildingNumber or a Postbox for a StructuredDK address type</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredLax') and cac:AddressLine">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'StructuredLax') and cac:AddressLine">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB036] AddressLine elements not allowed for a StructuredLax address type</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredID') and (not(cbc:ID) or cbc:ID = '')">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'StructuredID') and (not(cbc:ID) or cbc:ID = '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB037] ID is required for a StructuredID address type</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredID') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'StructuredID') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB038] Only the ID is used for a StructuredID address type</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredRegion') and ((not(cac:Country/cbc:IdentificationCode) or cac:Country/cbc:IdentificationCode = '') and (not(cbc:Region) or cbc:Region = '') and (not(cbc:District) or cbc:District = ''))">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'StructuredRegion') and ((not(cac:Country/cbc:IdentificationCode) or cac:Country/cbc:IdentificationCode = '') and (not(cbc:Region) or cbc:Region = '') and (not(cbc:District) or cbc:District = ''))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB039] Region or District or Country/IdentificationCode is required for a StructuredRegion address type</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredRegion') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0')">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'StructuredRegion') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB040] Only Region, District, and/or Country/IdentificationCode can be used for a StructuredRegion address type</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:ID and not(string-length(cbc:ID/@schemeID)>0)">
      <svrl:successful-report test="cbc:ID and not(string-length(cbc:ID/@schemeID)>0)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB028] When ID is used under Address the attribute schemeID is used to give an addressregister</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:ID and not(cbc:ID/@schemeID)">
      <svrl:successful-report test="cbc:ID and not(cbc:ID/@schemeID)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB029] schemeID attribute must be present on an address ID</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Country/cbc:IdentificationCode and not(contains($CountryCode, concat(',',cac:Country/cbc:IdentificationCode,',')))">
      <svrl:successful-report test="cac:Country/cbc:IdentificationCode and not(contains($CountryCode, concat(',',cac:Country/cbc:IdentificationCode,',')))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB301] Invalid Country/IdentificationCode: '<xsl:text />
          <xsl:value-of select="cac:Country/cbc:IdentificationCode" />
          <xsl:text />'. Must be a value from the codelist</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:AccountingSupplierParty/cac:Party/cac:PhysicalLocation" mode="M19" priority="1011">
    <svrl:fired-rule context="doc:Reminder/cac:AccountingSupplierParty/cac:Party/cac:PhysicalLocation" />

		<!--REPORT -->
<xsl:if test="(not(cbc:ID) or cbc:ID = '') and (count(cac:Address) = 0)">
      <svrl:successful-report test="(not(cbc:ID) or cbc:ID = '') and (count(cac:Address) = 0)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB221] If ID not specified, Address is mandatory</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:AccountingSupplierParty/cac:Party/cac:PhysicalLocation/cac:ValidityPeriod" mode="M19" priority="1010">
    <svrl:fired-rule context="doc:Reminder/cac:AccountingSupplierParty/cac:Party/cac:PhysicalLocation/cac:ValidityPeriod" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:DurationMeasure) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:DurationMeasure) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB076] DurationMeasure element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:DescriptionCode) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:DescriptionCode) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB077] DescriptionCode element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:StartTime) and (not(cbc:StartDate) or cbc:StartDate = '')">
      <svrl:successful-report test="(cbc:StartTime) and (not(cbc:StartDate) or cbc:StartDate = '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB078] There must be a StartDate if you have a StartTime</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:EndTime) and (not(cbc:EndDate) or cbc:EndDate = '')">
      <svrl:successful-report test="(cbc:EndTime) and (not(cbc:EndDate) or cbc:EndDate = '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB079] There must be a EndDate if you have a EndTime</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:StartDate and cbc:EndDate) and not(number(translate(cbc:EndDate,'-','')) > number(translate(cbc:StartDate,'-','')) or number(translate(cbc:EndDate,'-','')) = number(translate(cbc:StartDate,'-','')))">
      <svrl:successful-report test="(cbc:StartDate and cbc:EndDate) and not(number(translate(cbc:EndDate,'-','')) > number(translate(cbc:StartDate,'-','')) or number(translate(cbc:EndDate,'-','')) = number(translate(cbc:StartDate,'-','')))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB080] The EndDate must be greater or equal to the startdate</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:StartTime and cbc:EndTime) and not(number(translate(cbc:EndTime,':','')) > number(translate(cbc:StartTime,':','')) or number(translate(cbc:EndTime,':','')) = number(translate(cbc:StartTime,':','')))">
      <svrl:successful-report test="(cbc:StartTime and cbc:EndTime) and not(number(translate(cbc:EndTime,':','')) > number(translate(cbc:StartTime,':','')) or number(translate(cbc:EndTime,':','')) = number(translate(cbc:StartTime,':','')))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB081] EndTime must be greater or equal to StartTime</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:AccountingSupplierParty/cac:Party/cac:PhysicalLocation/cac:ValidityPeriod/cbc:Description" mode="M19" priority="1009">
    <svrl:fired-rule context="doc:Reminder/cac:AccountingSupplierParty/cac:Party/cac:PhysicalLocation/cac:ValidityPeriod/cbc:Description" />

		<!--REPORT -->
<xsl:if test="count(../cbc:Description) > 1 and not(./@languageID)">
      <svrl:successful-report test="count(../cbc:Description) > 1 and not(./@languageID)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[W-LIB222] The attribute languageID should be used when more than one Description element is present</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID">
      <svrl:successful-report test="local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[W-LIB223] Multilanguage error. Replicated Description elements with same languageID attribute value</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:AccountingSupplierParty/cac:Party/cac:PhysicalLocation/cac:Address" mode="M19" priority="1008">
    <svrl:fired-rule context="doc:Reminder/cac:AccountingSupplierParty/cac:Party/cac:PhysicalLocation/cac:Address" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:BlockName) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:BlockName) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB210] BlockName element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:TimezoneOffset) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:TimezoneOffset) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB211] TimezoneOffset element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:LocationCoordinate) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:LocationCoordinate) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB212] LocationCoordinate class must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:AddressFormatCode) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:AddressFormatCode) != ''">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB025] Invalid AddressFormatCode. Must contain a value</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listID = 'urn:oioubl:codelist:addresstypecode-1.1')">
      <svrl:successful-report test="cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listID = 'urn:oioubl:codelist:addresstypecode-1.1')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB204] Invalid listID. Must be 'urn:oioubl:codelist:addresstypecode-1.1'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listAgencyID = '320')">
      <svrl:successful-report test="cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listAgencyID = '320')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB205] Invalid listAgencyID. Must be '320'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode = 'Home' or cbc:AddressTypeCode = 'Business' )">
      <svrl:successful-report test="cbc:AddressTypeCode and not(cbc:AddressTypeCode = 'Home' or cbc:AddressTypeCode = 'Business' )">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB206] Invalid AddressTypeCode. Must be a value from the codelist</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:AddressFormatCode/@listID = 'urn:oioubl:codelist:addressformatcode-1.1' or cbc:AddressFormatCode/@listID = 'UN/ECE 3477'" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:AddressFormatCode/@listID = 'urn:oioubl:codelist:addressformatcode-1.1' or cbc:AddressFormatCode/@listID = 'UN/ECE 3477'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB026] Invalid listID. Must be either 'urn:oioubl:codelist:addressformatcode-1.1' or 'UN/ECE 3477'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'urn:oioubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode/@listAgencyID = '320')">
      <svrl:successful-report test="cbc:AddressFormatCode/@listID = 'urn:oioubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode/@listAgencyID = '320')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB207] Invalid listAgencyID. Must be '320'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'urn:oioubl:codelist:addressformatcode-1.1' and not(normalize-space(cbc:AddressFormatCode) = 'StructuredDK' or normalize-space(cbc:AddressFormatCode) = 'StructuredLax' or normalize-space(cbc:AddressFormatCode) = 'StructuredID' or normalize-space(cbc:AddressFormatCode) = 'StructuredRegion' or normalize-space(cbc:AddressFormatCode) = 'Unstructured')">
      <svrl:successful-report test="cbc:AddressFormatCode/@listID = 'urn:oioubl:codelist:addressformatcode-1.1' and not(normalize-space(cbc:AddressFormatCode) = 'StructuredDK' or normalize-space(cbc:AddressFormatCode) = 'StructuredLax' or normalize-space(cbc:AddressFormatCode) = 'StructuredID' or normalize-space(cbc:AddressFormatCode) = 'StructuredRegion' or normalize-space(cbc:AddressFormatCode) = 'Unstructured')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB027] Invalid AddressFormatCode. Must be a value from the codelist</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode/@listAgencyID = '6')">
      <svrl:successful-report test="cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode/@listAgencyID = '6')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB208] Invalid listAgencyID. Must be '6'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode = '1' or cbc:AddressFormatCode = '2' or cbc:AddressFormatCode = '3' or cbc:AddressFormatCode = '4' or cbc:AddressFormatCode = '5' or cbc:AddressFormatCode = '6' or cbc:AddressFormatCode = '7' or cbc:AddressFormatCode = '8' or cbc:AddressFormatCode = '9')">
      <svrl:successful-report test="cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode = '1' or cbc:AddressFormatCode = '2' or cbc:AddressFormatCode = '3' or cbc:AddressFormatCode = '4' or cbc:AddressFormatCode = '5' or cbc:AddressFormatCode = '6' or cbc:AddressFormatCode = '7' or cbc:AddressFormatCode = '8' or cbc:AddressFormatCode = '9')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB209] Invalid AddressFormatCode. Must be a value from the codelist</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Country and not(cac:Country/cbc:IdentificationCode != '')">
      <svrl:successful-report test="cac:Country and not(cac:Country/cbc:IdentificationCode != '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB213] When Country is used, the element Country/IdentificationCode must be filled out</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'Unstructured') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'Unstructured') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB031] An Unstructured address is only allowed to have AddressLine elements</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and cac:AddressLine">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'StructuredDK') and cac:AddressLine">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB032] AddressLine elements not allowed for a StructuredDK address type</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and (not(cbc:PostalZone) or normalize-space(cbc:PostalZone) = '')">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'StructuredDK') and (not(cbc:PostalZone) or normalize-space(cbc:PostalZone) = '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB033] PostalZone is mandatory for a StructuredDK address type</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:StreetName) or normalize-space(cbc:StreetName) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:StreetName) or normalize-space(cbc:StreetName) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB034] There should be either a StreetName or a Postbox for a StructuredDK address type</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:BuildingNumber) or normalize-space(cbc:BuildingNumber) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:BuildingNumber) or normalize-space(cbc:BuildingNumber) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB035] There should be either a BuildingNumber or a Postbox for a StructuredDK address type</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredLax') and cac:AddressLine">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'StructuredLax') and cac:AddressLine">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB036] AddressLine elements not allowed for a StructuredLax address type</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredID') and (not(cbc:ID) or cbc:ID = '')">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'StructuredID') and (not(cbc:ID) or cbc:ID = '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB037] ID is required for a StructuredID address type</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredID') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'StructuredID') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB038] Only the ID is used for a StructuredID address type</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredRegion') and ((not(cac:Country/cbc:IdentificationCode) or cac:Country/cbc:IdentificationCode = '') and (not(cbc:Region) or cbc:Region = '') and (not(cbc:District) or cbc:District = ''))">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'StructuredRegion') and ((not(cac:Country/cbc:IdentificationCode) or cac:Country/cbc:IdentificationCode = '') and (not(cbc:Region) or cbc:Region = '') and (not(cbc:District) or cbc:District = ''))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB039] Region or District or Country/IdentificationCode is required for a StructuredRegion address type</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredRegion') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0')">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'StructuredRegion') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB040] Only Region, District, and/or Country/IdentificationCode can be used for a StructuredRegion address type</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:ID and not(string-length(cbc:ID/@schemeID)>0)">
      <svrl:successful-report test="cbc:ID and not(string-length(cbc:ID/@schemeID)>0)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB028] When ID is used under Address the attribute schemeID is used to give an addressregister</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:ID and not(cbc:ID/@schemeID)">
      <svrl:successful-report test="cbc:ID and not(cbc:ID/@schemeID)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB029] schemeID attribute must be present on an address ID</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Country/cbc:IdentificationCode and not(contains($CountryCode, concat(',',cac:Country/cbc:IdentificationCode,',')))">
      <svrl:successful-report test="cac:Country/cbc:IdentificationCode and not(contains($CountryCode, concat(',',cac:Country/cbc:IdentificationCode,',')))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB301] Invalid Country/IdentificationCode: '<xsl:text />
          <xsl:value-of select="cac:Country/cbc:IdentificationCode" />
          <xsl:text />'. Must be a value from the codelist</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme" mode="M19" priority="1007">
    <svrl:fired-rule context="doc:Reminder/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:TaxLevelCode) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:TaxLevelCode) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB192] TaxLevelCode element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:CompanyID) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:CompanyID) != ''">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB193] Invalid CompanyID. Must contain a value</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:CompanyID/@schemeID = 'DK:SE' or cbc:CompanyID/@schemeID = 'ZZZ' " />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:CompanyID/@schemeID = 'DK:SE' or cbc:CompanyID/@schemeID = 'ZZZ'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB195] Invalid schemeID. Must be a valid scheme for PartyTaxScheme/CompanyID</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:CompanyID/@schemeID = 'DK:SE') and (string-length(normalize-space(cbc:CompanyID)) != 10 or substring(cbc:CompanyID, 1, 2) != 'DK')">
      <svrl:successful-report test="(cbc:CompanyID/@schemeID = 'DK:SE') and (string-length(normalize-space(cbc:CompanyID)) != 10 or substring(cbc:CompanyID, 1, 2) != 'DK')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB196] schemeID = DK:SE, CompanyID must be a valid SE number (like 'DK12345678', value found: '<xsl:text />
          <xsl:value-of select="cbc:CompanyID" />
          <xsl:text />')</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme" mode="M19" priority="1006">
    <svrl:fired-rule context="doc:Reminder/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:ID) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:ID) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB041] ID element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:AddressTypeCode) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:AddressTypeCode) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB042] AddressTypeCode element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:Postbox) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:Postbox) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB043] Postbox element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:Floor) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:Floor) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB044] Floor element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:Room) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:Room) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB045] Room element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:StreetName) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:StreetName) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB046] StreetName element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:AdditionalStreetName) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:AdditionalStreetName) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB047] AdditionalStreetName element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:BlockName) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:BlockName) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB048] BlockName element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:BuildingName) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:BuildingName) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB049] BuildingName element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:BuildingNumber) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:BuildingNumber) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB050] BuildingNumber element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:InhouseMail) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:InhouseMail) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB051] InhouseMail element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:Department) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:Department) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB052] Department element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:MarkAttention) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:MarkAttention) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB053] MarkAttention element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:MarkCare) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:MarkCare) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB054] MarkCare element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:PlotIdentification) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:PlotIdentification) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB055] PlotIdentification element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:CitySubdivisionName) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:CitySubdivisionName) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB056] CitySubdivisionName element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:CityName) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:CityName) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB057] CityName element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:PostalZone) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:PostalZone) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB058] PostalZone element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:CountrySubentity) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:CountrySubentity) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB059] CountrySubentity element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:CountrySubentityCode) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:CountrySubentityCode) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB060] CountrySubentityCode element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:TimezoneOffset) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:TimezoneOffset) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB063] TimezoneOffset element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cac:AddressLine) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cac:AddressLine) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB234] AddressLine class must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cac:LocationCoordinate) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cac:LocationCoordinate) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB064] LocationCoordinate class must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:ID = '63') and cbc:TaxTypeCode">
      <svrl:successful-report test="(cbc:ID = '63') and cbc:TaxTypeCode">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB067] TaxTypeCode is not allowed when TaxScheme/ID equals '63' (Moms)</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:ID) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:ID) != ''">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB065] Invalid TaxScheme/ID. Must contain a value.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:Name) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:Name) != ''">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB066] Invalid Name. Must contain a value</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="not((cbc:ID = '63' or cbc:ID = 'VAT')) and not(contains($TaxType2, concat(',',cbc:TaxTypeCode,',')))">
      <svrl:successful-report test="not((cbc:ID = '63' or cbc:ID = 'VAT')) and not(contains($TaxType2, concat(',',cbc:TaxTypeCode,',')))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB197] TaxTypeCode must be a value from the '<xsl:text />
          <xsl:value-of select="$TaxType_listID2" />
          <xsl:text />' codelist when TaxScheme/ID is different from '63' or 'VAT' (Moms)</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID/@schemeID = $TaxScheme_schemeID or cbc:ID/@schemeID = $TaxScheme2_schemeID or cbc:ID/@schemeID = $TaxScheme4_schemeID or cbc:ID/@schemeID = $TaxScheme5_schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID/@schemeID = $TaxScheme_schemeID or cbc:ID/@schemeID = $TaxScheme2_schemeID or cbc:ID/@schemeID = $TaxScheme4_schemeID or cbc:ID/@schemeID = $TaxScheme5_schemeID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB070] Invalid schemeID. Must be either '<xsl:text />
            <xsl:value-of select="$TaxScheme_schemeID" />
            <xsl:text />', '<xsl:text />
            <xsl:value-of select="$TaxScheme2_schemeID" />
            <xsl:text />', '<xsl:text />
            <xsl:value-of select="$TaxScheme4_schemeID" />
            <xsl:text />' or '<xsl:text />
            <xsl:value-of select="$TaxScheme5_schemeID" />
            <xsl:text />'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:TaxTypeCode) and not((cbc:TaxTypeCode/@listID = $TaxType_listID) or (cbc:TaxTypeCode/@listID = $TaxType_listID2))">
      <svrl:successful-report test="(cbc:TaxTypeCode) and not((cbc:TaxTypeCode/@listID = $TaxType_listID) or (cbc:TaxTypeCode/@listID = $TaxType_listID2))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB071] Invalid listID. Must be either '<xsl:text />
          <xsl:value-of select="$TaxType_listID" />
          <xsl:text />' or '<xsl:text />
          <xsl:value-of select="$TaxType_listID2" />
          <xsl:text />'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID = '63') and cbc:Name != 'Moms'">
      <svrl:successful-report test="(cbc:ID = '63') and cbc:Name != 'Moms'">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB198] Name must equal 'Moms' when TaxScheme/ID equals '63' (Moms)</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID != '63') and cbc:Name = 'Moms'">
      <svrl:successful-report test="(cbc:ID != '63') and cbc:Name = 'Moms'">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB199] Name must correspond to the value of TaxScheme/ID</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cac:JurisdictionRegionAddress/cac:Country/cbc:IdentificationCode) and not(contains($CountryCode, concat(',',cac:JurisdictionRegionAddress/cac:Country/cbc:IdentificationCode,',')))">
      <svrl:successful-report test="(cac:JurisdictionRegionAddress/cac:Country/cbc:IdentificationCode) and not(contains($CountryCode, concat(',',cac:JurisdictionRegionAddress/cac:Country/cbc:IdentificationCode,',')))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB337] Invalid Country/IdentificationCode: '<xsl:text />
          <xsl:value-of select="cac:JurisdictionRegionAddress/cac:Country/cbc:IdentificationCode" />
          <xsl:text />'. Must be a value from the country codelist</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cac:JurisdictionRegionAddress) and cac:JurisdictionRegionAddress/cbc:AddressFormatCode != 'StructuredRegion'">
      <svrl:successful-report test="(cac:JurisdictionRegionAddress) and cac:JurisdictionRegionAddress/cbc:AddressFormatCode != 'StructuredRegion'">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB233] The AddressFormatCode under JurisdictionRegionAddress must always equal 'StructuredRegion'</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity" mode="M19" priority="1005">
    <svrl:fired-rule context="doc:Reminder/cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:CorporateRegistrationScheme) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:CorporateRegistrationScheme) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB186] CorporateRegistrationScheme class must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:CompanyID) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:CompanyID) != ''">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB187] Invalid CompanyID. Must contain a value</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:CompanyID/@schemeID = 'DK:CVR' or cbc:CompanyID/@schemeID = 'DK:CPR' or cbc:CompanyID/@schemeID = 'ZZZ'" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:CompanyID/@schemeID = 'DK:CVR' or cbc:CompanyID/@schemeID = 'DK:CPR' or cbc:CompanyID/@schemeID = 'ZZZ'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB189] Invalid schemeID. Must be a valid scheme for PartyLegalEntity/CompanyID</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:CompanyID/@schemeID = 'DK:CVR') and (string-length(normalize-space(cbc:CompanyID)) != 10 or substring(cbc:CompanyID, 1, 2) != 'DK')">
      <svrl:successful-report test="(cbc:CompanyID/@schemeID = 'DK:CVR') and (string-length(normalize-space(cbc:CompanyID)) != 10 or substring(cbc:CompanyID, 1, 2) != 'DK')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB190] schemeID = DK:CVR, CompanyID must be a valid CVR number (like 'DK12345678', value found: '<xsl:text />
          <xsl:value-of select="cbc:CompanyID" />
          <xsl:text />')</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:CompanyID/@schemeID = 'DK:CPR') and not(string-length(cbc:CompanyID) = 10)">
      <svrl:successful-report test="(cbc:CompanyID/@schemeID = 'DK:CPR') and not(string-length(cbc:CompanyID) = 10)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB191] schemeID = DK:CPR, CompanyID must be a valid CPR number (like '1234560000', value found: '<xsl:text />
          <xsl:value-of select="cbc:CompanyID" />
          <xsl:text />')</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:AccountingSupplierParty/cac:Party/cac:Contact" mode="M19" priority="1004">
    <svrl:fired-rule context="doc:Reminder/cac:AccountingSupplierParty/cac:Party/cac:Contact" />

		<!--REPORT -->
<xsl:if test="(not(cbc:ID) or cbc:ID = '') and (not(cbc:Name) or cbc:Name = '') and (not(cbc:Telephone) or cbc:Telephone = '') and (not(cbc:Telefax) or cbc:Telefax = '') and (not(cbc:ElectronicMail) or cbc:ElectronicMail = '') and (not(cbc:Note) or cbc:Note = '') and not(cac:OtherCommunication)">
      <svrl:successful-report test="(not(cbc:ID) or cbc:ID = '') and (not(cbc:Name) or cbc:Name = '') and (not(cbc:Telephone) or cbc:Telephone = '') and (not(cbc:Telefax) or cbc:Telefax = '') and (not(cbc:ElectronicMail) or cbc:ElectronicMail = '') and (not(cbc:Note) or cbc:Note = '') and not(cac:OtherCommunication)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB235] At least one field in the Contact class should be specified</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:OtherCommunication/cbc:ChannelCode and cac:OtherCommunication/cbc:Channel">
      <svrl:successful-report test="cac:OtherCommunication/cbc:ChannelCode and cac:OtherCommunication/cbc:Channel">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB236] Use either ChannelCode or Channel</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:OtherCommunication and (normalize-space(cac:OtherCommunication/cbc:Value) = '')">
      <svrl:successful-report test="cac:OtherCommunication and (normalize-space(cac:OtherCommunication/cbc:Value) = '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB237] When Contact/OtherCommunication is used, the element Contact/OtherCommunication/Value must be filled out.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:AccountingSupplierParty/cac:Party/cac:Person" mode="M19" priority="1003">
    <svrl:fired-rule context="doc:Reminder/cac:AccountingSupplierParty/cac:Party/cac:Person" />

		<!--REPORT -->
<xsl:if test="(not(cbc:FamilyName) or cbc:FamilyName = '') and (not(cbc:FirstName) or cbc:FirstName = '')">
      <svrl:successful-report test="(not(cbc:FamilyName) or cbc:FamilyName = '') and (not(cbc:FirstName) or cbc:FirstName = '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB024] There must be a FirstName if the FamilyName is not present</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:SellerSupplierParty/cac:DespatchContact" mode="M19" priority="1002">
    <svrl:fired-rule context="doc:Reminder/cac:SellerSupplierParty/cac:DespatchContact" />

		<!--REPORT -->
<xsl:if test="(not(cbc:ID) or cbc:ID = '') and (not(cbc:Name) or cbc:Name = '') and (not(cbc:Telephone) or cbc:Telephone = '') and (not(cbc:Telefax) or cbc:Telefax = '') and (not(cbc:ElectronicMail) or cbc:ElectronicMail = '') and (not(cbc:Note) or cbc:Note = '') and not(cac:OtherCommunication)">
      <svrl:successful-report test="(not(cbc:ID) or cbc:ID = '') and (not(cbc:Name) or cbc:Name = '') and (not(cbc:Telephone) or cbc:Telephone = '') and (not(cbc:Telefax) or cbc:Telefax = '') and (not(cbc:ElectronicMail) or cbc:ElectronicMail = '') and (not(cbc:Note) or cbc:Note = '') and not(cac:OtherCommunication)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB235] At least one field in the Contact class should be specified</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:OtherCommunication/cbc:ChannelCode and cac:OtherCommunication/cbc:Channel">
      <svrl:successful-report test="cac:OtherCommunication/cbc:ChannelCode and cac:OtherCommunication/cbc:Channel">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB236] Use either ChannelCode or Channel</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:OtherCommunication and (normalize-space(cac:OtherCommunication/cbc:Value) = '')">
      <svrl:successful-report test="cac:OtherCommunication and (normalize-space(cac:OtherCommunication/cbc:Value) = '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB237] When Contact/OtherCommunication is used, the element Contact/OtherCommunication/Value must be filled out.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:SellerSupplierParty/cac:AccountingContact" mode="M19" priority="1001">
    <svrl:fired-rule context="doc:Reminder/cac:SellerSupplierParty/cac:AccountingContact" />

		<!--REPORT -->
<xsl:if test="(not(cbc:ID) or cbc:ID = '') and (not(cbc:Name) or cbc:Name = '') and (not(cbc:Telephone) or cbc:Telephone = '') and (not(cbc:Telefax) or cbc:Telefax = '') and (not(cbc:ElectronicMail) or cbc:ElectronicMail = '') and (not(cbc:Note) or cbc:Note = '') and not(cac:OtherCommunication)">
      <svrl:successful-report test="(not(cbc:ID) or cbc:ID = '') and (not(cbc:Name) or cbc:Name = '') and (not(cbc:Telephone) or cbc:Telephone = '') and (not(cbc:Telefax) or cbc:Telefax = '') and (not(cbc:ElectronicMail) or cbc:ElectronicMail = '') and (not(cbc:Note) or cbc:Note = '') and not(cac:OtherCommunication)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB235] At least one field in the Contact class should be specified</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:OtherCommunication/cbc:ChannelCode and cac:OtherCommunication/cbc:Channel">
      <svrl:successful-report test="cac:OtherCommunication/cbc:ChannelCode and cac:OtherCommunication/cbc:Channel">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB236] Use either ChannelCode or Channel</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:OtherCommunication and (normalize-space(cac:OtherCommunication/cbc:Value) = '')">
      <svrl:successful-report test="cac:OtherCommunication and (normalize-space(cac:OtherCommunication/cbc:Value) = '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB237] When Contact/OtherCommunication is used, the element Contact/OtherCommunication/Value must be filled out.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:SellerSupplierParty/cac:SellerContact" mode="M19" priority="1000">
    <svrl:fired-rule context="doc:Reminder/cac:SellerSupplierParty/cac:SellerContact" />

		<!--REPORT -->
<xsl:if test="(not(cbc:ID) or cbc:ID = '') and (not(cbc:Name) or cbc:Name = '') and (not(cbc:Telephone) or cbc:Telephone = '') and (not(cbc:Telefax) or cbc:Telefax = '') and (not(cbc:ElectronicMail) or cbc:ElectronicMail = '') and (not(cbc:Note) or cbc:Note = '') and not(cac:OtherCommunication)">
      <svrl:successful-report test="(not(cbc:ID) or cbc:ID = '') and (not(cbc:Name) or cbc:Name = '') and (not(cbc:Telephone) or cbc:Telephone = '') and (not(cbc:Telefax) or cbc:Telefax = '') and (not(cbc:ElectronicMail) or cbc:ElectronicMail = '') and (not(cbc:Note) or cbc:Note = '') and not(cac:OtherCommunication)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB235] At least one field in the Contact class should be specified</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:OtherCommunication/cbc:ChannelCode and cac:OtherCommunication/cbc:Channel">
      <svrl:successful-report test="cac:OtherCommunication/cbc:ChannelCode and cac:OtherCommunication/cbc:Channel">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB236] Use either ChannelCode or Channel</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:OtherCommunication and (normalize-space(cac:OtherCommunication/cbc:Value) = '')">
      <svrl:successful-report test="cac:OtherCommunication and (normalize-space(cac:OtherCommunication/cbc:Value) = '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB237] When Contact/OtherCommunication is used, the element Contact/OtherCommunication/Value must be filled out.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M19" priority="-1" />
  <xsl:template match="@*|node()" mode="M19" priority="-2">
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN accountingcustomerparty-->


	<!--RULE -->
<xsl:template match="doc:Reminder/cac:AccountingCustomerParty" mode="M20" priority="1016">
    <svrl:fired-rule context="doc:Reminder/cac:AccountingCustomerParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:Party) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:Party) = 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-REM024] One Party class must be present</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:AccountingCustomerParty/cac:Party" mode="M20" priority="1015">
    <svrl:fired-rule context="doc:Reminder/cac:AccountingCustomerParty/cac:Party" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:MarkCareIndicator) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:MarkCareIndicator) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB166] MarkCareIndicator element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:MarkAttentionIndicator) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:MarkAttentionIndicator) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB167] MarkAttentionIndicator element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:AgentParty) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:AgentParty) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB168] AgentParty class must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:EndpointID) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:EndpointID) != ''">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-REM025] Invalid EndpointID. Must contain a value</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:Contact) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:Contact) = 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-REM071] One Contact class must be present</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="(not(cac:PartyIdentification) or cac:PartyIdentification/cbc:ID = '') and (not(cac:PartyName) or cac:PartyName/cbc:Name = '')">
      <svrl:successful-report test="(not(cac:PartyIdentification) or cac:PartyIdentification/cbc:ID = '') and (not(cac:PartyName) or cac:PartyName/cbc:Name = '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB022] PartyName/Name is mandatory if PartyIdentification/ID is not found</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:EndpointID and not(contains($EndpointID_schemeID, concat(',',cbc:EndpointID/@schemeID,',')))">
      <svrl:successful-report test="cbc:EndpointID and not(contains($EndpointID_schemeID, concat(',',cbc:EndpointID/@schemeID,',')))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB179] Invalid schemeID: '<xsl:text />
          <xsl:value-of select="cbc:EndpointID/@schemeID" />
          <xsl:text />'. Must be a value from the codelist: '<xsl:text />
          <xsl:value-of select="$EndpointID_schemeID" />
          <xsl:text />'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:EndpointID/@schemeID = 'DK:CVR') and (string-length(cbc:EndpointID) != 10 or substring(cbc:EndpointID, 1, 2) != 'DK')">
      <svrl:successful-report test="(cbc:EndpointID/@schemeID = 'DK:CVR') and (string-length(cbc:EndpointID) != 10 or substring(cbc:EndpointID, 1, 2) != 'DK')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB180] schemeID = DK:CVR, EndpointID must be a valid CVR number (like 'DK12345678', value found: '<xsl:text />
          <xsl:value-of select="cbc:EndpointID" />
          <xsl:text />')</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:EndpointID/@schemeID = 'DK:CPR') and not(string-length(cbc:EndpointID) = 10)">
      <svrl:successful-report test="(cbc:EndpointID/@schemeID = 'DK:CPR') and not(string-length(cbc:EndpointID) = 10)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB215] schemeID = DK:CPR, EndpointID must be a valid CPR number (like '1234560000', value found: '<xsl:text />
          <xsl:value-of select="cbc:EndpointID" />
          <xsl:text />')</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:EndpointID/@schemeID = 'GLN') and not(string-length(cbc:EndpointID) = 13)">
      <svrl:successful-report test="(cbc:EndpointID/@schemeID = 'GLN') and not(string-length(cbc:EndpointID) = 13)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB181] schemeID = GLN, EndpointID must be a valid GLN number (like '1234567890123', value found: '<xsl:text />
          <xsl:value-of select="cbc:EndpointID" />
          <xsl:text />')</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:EndpointID/@schemeID = 'EAN') and not(string-length(cbc:EndpointID) = 13)">
      <svrl:successful-report test="(cbc:EndpointID/@schemeID = 'EAN') and not(string-length(cbc:EndpointID) = 13)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB216] schemeID = EAN, EndpointID must be a valid EAN number (like '1234567890123', value found: '<xsl:text />
          <xsl:value-of select="cbc:EndpointID" />
          <xsl:text />')</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="count(cac:PartyLegalEntity) > 1">
      <svrl:successful-report test="count(cac:PartyLegalEntity) > 1">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-REM093] No more than one PartyLegalEntity class may be present</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M20" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification" mode="M20" priority="1014">
    <svrl:fired-rule context="doc:Reminder/cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification" />

		<!--REPORT -->
<xsl:if test="not(contains($PartyID_schemeID, concat(',',cbc:ID/@schemeID,',')))">
      <svrl:successful-report test="not(contains($PartyID_schemeID, concat(',',cbc:ID/@schemeID,',')))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB183] Invalid schemeID: '<xsl:text />
          <xsl:value-of select="cbc:ID/@schemeID" />
          <xsl:text />'. Must be a value from the codelist: '<xsl:text />
          <xsl:value-of select="$PartyID_schemeID" />
          <xsl:text />'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID/@schemeID = 'DK:CVR') and (string-length(cbc:ID) != 10 or substring(cbc:ID, 1, 2) != 'DK')">
      <svrl:successful-report test="(cbc:ID/@schemeID = 'DK:CVR') and (string-length(cbc:ID) != 10 or substring(cbc:ID, 1, 2) != 'DK')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB184] schemeID = DK:CVR, ID must be a valid CVR number (like 'DK12345678', value found: '<xsl:text />
          <xsl:value-of select="cbc:ID" />
          <xsl:text />')</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID/@schemeID = 'DK:CPR') and not(string-length(cbc:ID) = 10)">
      <svrl:successful-report test="(cbc:ID/@schemeID = 'DK:CPR') and not(string-length(cbc:ID) = 10)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB217] schemeID = DK:CPR, ID must be a valid CPR number (like '1234560000', value found: '<xsl:text />
          <xsl:value-of select="cbc:ID" />
          <xsl:text />')</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID/@schemeID = 'GLN') and not(string-length(cbc:ID) = 13)">
      <svrl:successful-report test="(cbc:ID/@schemeID = 'GLN') and not(string-length(cbc:ID) = 13)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB185] schemeID = GLN, ID must be a valid GLN number (like '1234567890123', value found: '<xsl:text />
          <xsl:value-of select="cbc:ID" />
          <xsl:text />')</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID/@schemeID = 'EAN') and not(string-length(cbc:ID) = 13)">
      <svrl:successful-report test="(cbc:ID/@schemeID = 'EAN') and not(string-length(cbc:ID) = 13)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB218] schemeID = EAN, ID must be a valid EAN number (like '1234567890123', value found: '<xsl:text />
          <xsl:value-of select="cbc:ID" />
          <xsl:text />')</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID/@schemeID = 'DK:P') and not(string-length(cbc:ID) = 10)">
      <svrl:successful-report test="(cbc:ID/@schemeID = 'DK:P') and not(string-length(cbc:ID) = 10)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB287] schemeID = DK:P, ID must be a valid P number (like '1234567890', value found: '<xsl:text />
          <xsl:value-of select="cbc:ID" />
          <xsl:text />')</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M20" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:AccountingCustomerParty/cac:Party/cac:PartyName" mode="M20" priority="1013">
    <svrl:fired-rule context="doc:Reminder/cac:AccountingCustomerParty/cac:Party/cac:PartyName" />

		<!--REPORT -->
<xsl:if test="count(../cac:PartyName) > 1 and not(./cbc:Name/@languageID)">
      <svrl:successful-report test="count(../cac:PartyName) > 1 and not(./cbc:Name/@languageID)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[W-LIB219] The attribute Name@languageID should be used when more than one PartyName class is present</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="local-name(following-sibling::*) = local-name(current()) and following-sibling::*/cbc:Name/@languageID = self::*/cbc:Name/@languageID">
      <svrl:successful-report test="local-name(following-sibling::*) = local-name(current()) and following-sibling::*/cbc:Name/@languageID = self::*/cbc:Name/@languageID">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[W-LIB220] Multilanguage error. Replicated PartyName classes with same Name@languageID attribute value</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M20" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress" mode="M20" priority="1012">
    <svrl:fired-rule context="doc:Reminder/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:BlockName) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:BlockName) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB210] BlockName element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:TimezoneOffset) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:TimezoneOffset) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB211] TimezoneOffset element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:LocationCoordinate) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:LocationCoordinate) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB212] LocationCoordinate class must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:AddressFormatCode) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:AddressFormatCode) != ''">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB025] Invalid AddressFormatCode. Must contain a value</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listID = 'urn:oioubl:codelist:addresstypecode-1.1')">
      <svrl:successful-report test="cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listID = 'urn:oioubl:codelist:addresstypecode-1.1')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB204] Invalid listID. Must be 'urn:oioubl:codelist:addresstypecode-1.1'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listAgencyID = '320')">
      <svrl:successful-report test="cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listAgencyID = '320')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB205] Invalid listAgencyID. Must be '320'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode = 'Home' or cbc:AddressTypeCode = 'Business' )">
      <svrl:successful-report test="cbc:AddressTypeCode and not(cbc:AddressTypeCode = 'Home' or cbc:AddressTypeCode = 'Business' )">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB206] Invalid AddressTypeCode. Must be a value from the codelist</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:AddressFormatCode/@listID = 'urn:oioubl:codelist:addressformatcode-1.1' or cbc:AddressFormatCode/@listID = 'UN/ECE 3477'" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:AddressFormatCode/@listID = 'urn:oioubl:codelist:addressformatcode-1.1' or cbc:AddressFormatCode/@listID = 'UN/ECE 3477'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB026] Invalid listID. Must be either 'urn:oioubl:codelist:addressformatcode-1.1' or 'UN/ECE 3477'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'urn:oioubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode/@listAgencyID = '320')">
      <svrl:successful-report test="cbc:AddressFormatCode/@listID = 'urn:oioubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode/@listAgencyID = '320')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB207] Invalid listAgencyID. Must be '320'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'urn:oioubl:codelist:addressformatcode-1.1' and not(normalize-space(cbc:AddressFormatCode) = 'StructuredDK' or normalize-space(cbc:AddressFormatCode) = 'StructuredLax' or normalize-space(cbc:AddressFormatCode) = 'StructuredID' or normalize-space(cbc:AddressFormatCode) = 'StructuredRegion' or normalize-space(cbc:AddressFormatCode) = 'Unstructured')">
      <svrl:successful-report test="cbc:AddressFormatCode/@listID = 'urn:oioubl:codelist:addressformatcode-1.1' and not(normalize-space(cbc:AddressFormatCode) = 'StructuredDK' or normalize-space(cbc:AddressFormatCode) = 'StructuredLax' or normalize-space(cbc:AddressFormatCode) = 'StructuredID' or normalize-space(cbc:AddressFormatCode) = 'StructuredRegion' or normalize-space(cbc:AddressFormatCode) = 'Unstructured')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB027] Invalid AddressFormatCode. Must be a value from the codelist</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode/@listAgencyID = '6')">
      <svrl:successful-report test="cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode/@listAgencyID = '6')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB208] Invalid listAgencyID. Must be '6'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode = '1' or cbc:AddressFormatCode = '2' or cbc:AddressFormatCode = '3' or cbc:AddressFormatCode = '4' or cbc:AddressFormatCode = '5' or cbc:AddressFormatCode = '6' or cbc:AddressFormatCode = '7' or cbc:AddressFormatCode = '8' or cbc:AddressFormatCode = '9')">
      <svrl:successful-report test="cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode = '1' or cbc:AddressFormatCode = '2' or cbc:AddressFormatCode = '3' or cbc:AddressFormatCode = '4' or cbc:AddressFormatCode = '5' or cbc:AddressFormatCode = '6' or cbc:AddressFormatCode = '7' or cbc:AddressFormatCode = '8' or cbc:AddressFormatCode = '9')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB209] Invalid AddressFormatCode. Must be a value from the codelist</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Country and not(cac:Country/cbc:IdentificationCode != '')">
      <svrl:successful-report test="cac:Country and not(cac:Country/cbc:IdentificationCode != '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB213] When Country is used, the element Country/IdentificationCode must be filled out</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'Unstructured') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'Unstructured') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB031] An Unstructured address is only allowed to have AddressLine elements</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and cac:AddressLine">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'StructuredDK') and cac:AddressLine">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB032] AddressLine elements not allowed for a StructuredDK address type</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and (not(cbc:PostalZone) or normalize-space(cbc:PostalZone) = '')">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'StructuredDK') and (not(cbc:PostalZone) or normalize-space(cbc:PostalZone) = '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB033] PostalZone is mandatory for a StructuredDK address type</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:StreetName) or normalize-space(cbc:StreetName) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:StreetName) or normalize-space(cbc:StreetName) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB034] There should be either a StreetName or a Postbox for a StructuredDK address type</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:BuildingNumber) or normalize-space(cbc:BuildingNumber) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:BuildingNumber) or normalize-space(cbc:BuildingNumber) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB035] There should be either a BuildingNumber or a Postbox for a StructuredDK address type</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredLax') and cac:AddressLine">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'StructuredLax') and cac:AddressLine">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB036] AddressLine elements not allowed for a StructuredLax address type</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredID') and (not(cbc:ID) or cbc:ID = '')">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'StructuredID') and (not(cbc:ID) or cbc:ID = '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB037] ID is required for a StructuredID address type</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredID') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'StructuredID') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB038] Only the ID is used for a StructuredID address type</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredRegion') and ((not(cac:Country/cbc:IdentificationCode) or cac:Country/cbc:IdentificationCode = '') and (not(cbc:Region) or cbc:Region = '') and (not(cbc:District) or cbc:District = ''))">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'StructuredRegion') and ((not(cac:Country/cbc:IdentificationCode) or cac:Country/cbc:IdentificationCode = '') and (not(cbc:Region) or cbc:Region = '') and (not(cbc:District) or cbc:District = ''))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB039] Region or District or Country/IdentificationCode is required for a StructuredRegion address type</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredRegion') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0')">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'StructuredRegion') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB040] Only Region, District, and/or Country/IdentificationCode can be used for a StructuredRegion address type</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:ID and not(string-length(cbc:ID/@schemeID)>0)">
      <svrl:successful-report test="cbc:ID and not(string-length(cbc:ID/@schemeID)>0)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB028] When ID is used under Address the attribute schemeID is used to give an addressregister</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:ID and not(cbc:ID/@schemeID)">
      <svrl:successful-report test="cbc:ID and not(cbc:ID/@schemeID)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB029] schemeID attribute must be present on an address ID</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Country/cbc:IdentificationCode and not(contains($CountryCode, concat(',',cac:Country/cbc:IdentificationCode,',')))">
      <svrl:successful-report test="cac:Country/cbc:IdentificationCode and not(contains($CountryCode, concat(',',cac:Country/cbc:IdentificationCode,',')))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB301] Invalid Country/IdentificationCode: '<xsl:text />
          <xsl:value-of select="cac:Country/cbc:IdentificationCode" />
          <xsl:text />'. Must be a value from the codelist</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M20" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:AccountingCustomerParty/cac:Party/cac:PhysicalLocation" mode="M20" priority="1011">
    <svrl:fired-rule context="doc:Reminder/cac:AccountingCustomerParty/cac:Party/cac:PhysicalLocation" />

		<!--REPORT -->
<xsl:if test="(not(cbc:ID) or cbc:ID = '') and (count(cac:Address) = 0)">
      <svrl:successful-report test="(not(cbc:ID) or cbc:ID = '') and (count(cac:Address) = 0)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB221] If ID not specified, Address is mandatory</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M20" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:AccountingCustomerParty/cac:Party/cac:PhysicalLocation/cac:ValidityPeriod" mode="M20" priority="1010">
    <svrl:fired-rule context="doc:Reminder/cac:AccountingCustomerParty/cac:Party/cac:PhysicalLocation/cac:ValidityPeriod" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:DurationMeasure) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:DurationMeasure) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB076] DurationMeasure element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:DescriptionCode) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:DescriptionCode) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB077] DescriptionCode element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:StartTime) and (not(cbc:StartDate) or cbc:StartDate = '')">
      <svrl:successful-report test="(cbc:StartTime) and (not(cbc:StartDate) or cbc:StartDate = '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB078] There must be a StartDate if you have a StartTime</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:EndTime) and (not(cbc:EndDate) or cbc:EndDate = '')">
      <svrl:successful-report test="(cbc:EndTime) and (not(cbc:EndDate) or cbc:EndDate = '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB079] There must be a EndDate if you have a EndTime</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:StartDate and cbc:EndDate) and not(number(translate(cbc:EndDate,'-','')) > number(translate(cbc:StartDate,'-','')) or number(translate(cbc:EndDate,'-','')) = number(translate(cbc:StartDate,'-','')))">
      <svrl:successful-report test="(cbc:StartDate and cbc:EndDate) and not(number(translate(cbc:EndDate,'-','')) > number(translate(cbc:StartDate,'-','')) or number(translate(cbc:EndDate,'-','')) = number(translate(cbc:StartDate,'-','')))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB080] The EndDate must be greater or equal to the startdate</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:StartTime and cbc:EndTime) and not(number(translate(cbc:EndTime,':','')) > number(translate(cbc:StartTime,':','')) or number(translate(cbc:EndTime,':','')) = number(translate(cbc:StartTime,':','')))">
      <svrl:successful-report test="(cbc:StartTime and cbc:EndTime) and not(number(translate(cbc:EndTime,':','')) > number(translate(cbc:StartTime,':','')) or number(translate(cbc:EndTime,':','')) = number(translate(cbc:StartTime,':','')))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB081] EndTime must be greater or equal to StartTime</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M20" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:AccountingCustomerParty/cac:Party/cac:PhysicalLocation/cac:ValidityPeriod/cbc:Description" mode="M20" priority="1009">
    <svrl:fired-rule context="doc:Reminder/cac:AccountingCustomerParty/cac:Party/cac:PhysicalLocation/cac:ValidityPeriod/cbc:Description" />

		<!--REPORT -->
<xsl:if test="count(../cbc:Description) > 1 and not(./@languageID)">
      <svrl:successful-report test="count(../cbc:Description) > 1 and not(./@languageID)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[W-LIB222] The attribute languageID should be used when more than one Description element is present</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID">
      <svrl:successful-report test="local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[W-LIB223] Multilanguage error. Replicated Description elements with same languageID attribute value</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M20" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:AccountingCustomerParty/cac:Party/cac:PhysicalLocation/cac:Address" mode="M20" priority="1008">
    <svrl:fired-rule context="doc:Reminder/cac:AccountingCustomerParty/cac:Party/cac:PhysicalLocation/cac:Address" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:BlockName) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:BlockName) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB210] BlockName element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:TimezoneOffset) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:TimezoneOffset) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB211] TimezoneOffset element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:LocationCoordinate) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:LocationCoordinate) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB212] LocationCoordinate class must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:AddressFormatCode) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:AddressFormatCode) != ''">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB025] Invalid AddressFormatCode. Must contain a value</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listID = 'urn:oioubl:codelist:addresstypecode-1.1')">
      <svrl:successful-report test="cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listID = 'urn:oioubl:codelist:addresstypecode-1.1')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB204] Invalid listID. Must be 'urn:oioubl:codelist:addresstypecode-1.1'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listAgencyID = '320')">
      <svrl:successful-report test="cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listAgencyID = '320')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB205] Invalid listAgencyID. Must be '320'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode = 'Home' or cbc:AddressTypeCode = 'Business' )">
      <svrl:successful-report test="cbc:AddressTypeCode and not(cbc:AddressTypeCode = 'Home' or cbc:AddressTypeCode = 'Business' )">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB206] Invalid AddressTypeCode. Must be a value from the codelist</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:AddressFormatCode/@listID = 'urn:oioubl:codelist:addressformatcode-1.1' or cbc:AddressFormatCode/@listID = 'UN/ECE 3477'" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:AddressFormatCode/@listID = 'urn:oioubl:codelist:addressformatcode-1.1' or cbc:AddressFormatCode/@listID = 'UN/ECE 3477'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB026] Invalid listID. Must be either 'urn:oioubl:codelist:addressformatcode-1.1' or 'UN/ECE 3477'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'urn:oioubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode/@listAgencyID = '320')">
      <svrl:successful-report test="cbc:AddressFormatCode/@listID = 'urn:oioubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode/@listAgencyID = '320')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB207] Invalid listAgencyID. Must be '320'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'urn:oioubl:codelist:addressformatcode-1.1' and not(normalize-space(cbc:AddressFormatCode) = 'StructuredDK' or normalize-space(cbc:AddressFormatCode) = 'StructuredLax' or normalize-space(cbc:AddressFormatCode) = 'StructuredID' or normalize-space(cbc:AddressFormatCode) = 'StructuredRegion' or normalize-space(cbc:AddressFormatCode) = 'Unstructured')">
      <svrl:successful-report test="cbc:AddressFormatCode/@listID = 'urn:oioubl:codelist:addressformatcode-1.1' and not(normalize-space(cbc:AddressFormatCode) = 'StructuredDK' or normalize-space(cbc:AddressFormatCode) = 'StructuredLax' or normalize-space(cbc:AddressFormatCode) = 'StructuredID' or normalize-space(cbc:AddressFormatCode) = 'StructuredRegion' or normalize-space(cbc:AddressFormatCode) = 'Unstructured')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB027] Invalid AddressFormatCode. Must be a value from the codelist</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode/@listAgencyID = '6')">
      <svrl:successful-report test="cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode/@listAgencyID = '6')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB208] Invalid listAgencyID. Must be '6'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode = '1' or cbc:AddressFormatCode = '2' or cbc:AddressFormatCode = '3' or cbc:AddressFormatCode = '4' or cbc:AddressFormatCode = '5' or cbc:AddressFormatCode = '6' or cbc:AddressFormatCode = '7' or cbc:AddressFormatCode = '8' or cbc:AddressFormatCode = '9')">
      <svrl:successful-report test="cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode = '1' or cbc:AddressFormatCode = '2' or cbc:AddressFormatCode = '3' or cbc:AddressFormatCode = '4' or cbc:AddressFormatCode = '5' or cbc:AddressFormatCode = '6' or cbc:AddressFormatCode = '7' or cbc:AddressFormatCode = '8' or cbc:AddressFormatCode = '9')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB209] Invalid AddressFormatCode. Must be a value from the codelist</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Country and not(cac:Country/cbc:IdentificationCode != '')">
      <svrl:successful-report test="cac:Country and not(cac:Country/cbc:IdentificationCode != '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB213] When Country is used, the element Country/IdentificationCode must be filled out</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'Unstructured') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'Unstructured') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB031] An Unstructured address is only allowed to have AddressLine elements</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and cac:AddressLine">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'StructuredDK') and cac:AddressLine">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB032] AddressLine elements not allowed for a StructuredDK address type</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and (not(cbc:PostalZone) or normalize-space(cbc:PostalZone) = '')">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'StructuredDK') and (not(cbc:PostalZone) or normalize-space(cbc:PostalZone) = '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB033] PostalZone is mandatory for a StructuredDK address type</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:StreetName) or normalize-space(cbc:StreetName) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:StreetName) or normalize-space(cbc:StreetName) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB034] There should be either a StreetName or a Postbox for a StructuredDK address type</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:BuildingNumber) or normalize-space(cbc:BuildingNumber) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:BuildingNumber) or normalize-space(cbc:BuildingNumber) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB035] There should be either a BuildingNumber or a Postbox for a StructuredDK address type</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredLax') and cac:AddressLine">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'StructuredLax') and cac:AddressLine">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB036] AddressLine elements not allowed for a StructuredLax address type</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredID') and (not(cbc:ID) or cbc:ID = '')">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'StructuredID') and (not(cbc:ID) or cbc:ID = '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB037] ID is required for a StructuredID address type</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredID') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'StructuredID') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB038] Only the ID is used for a StructuredID address type</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredRegion') and ((not(cac:Country/cbc:IdentificationCode) or cac:Country/cbc:IdentificationCode = '') and (not(cbc:Region) or cbc:Region = '') and (not(cbc:District) or cbc:District = ''))">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'StructuredRegion') and ((not(cac:Country/cbc:IdentificationCode) or cac:Country/cbc:IdentificationCode = '') and (not(cbc:Region) or cbc:Region = '') and (not(cbc:District) or cbc:District = ''))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB039] Region or District or Country/IdentificationCode is required for a StructuredRegion address type</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredRegion') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0')">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'StructuredRegion') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB040] Only Region, District, and/or Country/IdentificationCode can be used for a StructuredRegion address type</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:ID and not(string-length(cbc:ID/@schemeID)>0)">
      <svrl:successful-report test="cbc:ID and not(string-length(cbc:ID/@schemeID)>0)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB028] When ID is used under Address the attribute schemeID is used to give an addressregister</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:ID and not(cbc:ID/@schemeID)">
      <svrl:successful-report test="cbc:ID and not(cbc:ID/@schemeID)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB029] schemeID attribute must be present on an address ID</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Country/cbc:IdentificationCode and not(contains($CountryCode, concat(',',cac:Country/cbc:IdentificationCode,',')))">
      <svrl:successful-report test="cac:Country/cbc:IdentificationCode and not(contains($CountryCode, concat(',',cac:Country/cbc:IdentificationCode,',')))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB301] Invalid Country/IdentificationCode: '<xsl:text />
          <xsl:value-of select="cac:Country/cbc:IdentificationCode" />
          <xsl:text />'. Must be a value from the codelist</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M20" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme" mode="M20" priority="1007">
    <svrl:fired-rule context="doc:Reminder/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:TaxLevelCode) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:TaxLevelCode) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB192] TaxLevelCode element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:CompanyID) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:CompanyID) != ''">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB193] Invalid CompanyID. Must contain a value</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:CompanyID/@schemeID = 'DK:SE' or cbc:CompanyID/@schemeID = 'ZZZ' " />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:CompanyID/@schemeID = 'DK:SE' or cbc:CompanyID/@schemeID = 'ZZZ'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB195] Invalid schemeID. Must be a valid scheme for PartyTaxScheme/CompanyID</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:CompanyID/@schemeID = 'DK:SE') and (string-length(normalize-space(cbc:CompanyID)) != 10 or substring(cbc:CompanyID, 1, 2) != 'DK')">
      <svrl:successful-report test="(cbc:CompanyID/@schemeID = 'DK:SE') and (string-length(normalize-space(cbc:CompanyID)) != 10 or substring(cbc:CompanyID, 1, 2) != 'DK')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB196] schemeID = DK:SE, CompanyID must be a valid SE number (like 'DK12345678', value found: '<xsl:text />
          <xsl:value-of select="cbc:CompanyID" />
          <xsl:text />')</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M20" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme" mode="M20" priority="1006">
    <svrl:fired-rule context="doc:Reminder/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:ID) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:ID) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB041] ID element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:AddressTypeCode) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:AddressTypeCode) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB042] AddressTypeCode element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:Postbox) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:Postbox) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB043] Postbox element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:Floor) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:Floor) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB044] Floor element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:Room) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:Room) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB045] Room element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:StreetName) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:StreetName) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB046] StreetName element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:AdditionalStreetName) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:AdditionalStreetName) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB047] AdditionalStreetName element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:BlockName) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:BlockName) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB048] BlockName element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:BuildingName) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:BuildingName) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB049] BuildingName element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:BuildingNumber) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:BuildingNumber) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB050] BuildingNumber element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:InhouseMail) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:InhouseMail) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB051] InhouseMail element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:Department) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:Department) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB052] Department element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:MarkAttention) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:MarkAttention) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB053] MarkAttention element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:MarkCare) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:MarkCare) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB054] MarkCare element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:PlotIdentification) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:PlotIdentification) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB055] PlotIdentification element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:CitySubdivisionName) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:CitySubdivisionName) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB056] CitySubdivisionName element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:CityName) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:CityName) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB057] CityName element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:PostalZone) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:PostalZone) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB058] PostalZone element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:CountrySubentity) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:CountrySubentity) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB059] CountrySubentity element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:CountrySubentityCode) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:CountrySubentityCode) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB060] CountrySubentityCode element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:TimezoneOffset) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:TimezoneOffset) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB063] TimezoneOffset element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cac:AddressLine) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cac:AddressLine) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB234] AddressLine class must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cac:LocationCoordinate) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cac:LocationCoordinate) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB064] LocationCoordinate class must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:ID = '63') and cbc:TaxTypeCode">
      <svrl:successful-report test="(cbc:ID = '63') and cbc:TaxTypeCode">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB067] TaxTypeCode is not allowed when TaxScheme/ID equals '63' (Moms)</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:ID) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:ID) != ''">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB065] Invalid TaxScheme/ID. Must contain a value.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:Name) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:Name) != ''">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB066] Invalid Name. Must contain a value</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="not((cbc:ID = '63' or cbc:ID = 'VAT')) and not(contains($TaxType2, concat(',',cbc:TaxTypeCode,',')))">
      <svrl:successful-report test="not((cbc:ID = '63' or cbc:ID = 'VAT')) and not(contains($TaxType2, concat(',',cbc:TaxTypeCode,',')))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB197] TaxTypeCode must be a value from the '<xsl:text />
          <xsl:value-of select="$TaxType_listID2" />
          <xsl:text />' codelist when TaxScheme/ID is different from '63' or 'VAT' (Moms)</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID/@schemeID = $TaxScheme_schemeID or cbc:ID/@schemeID = $TaxScheme2_schemeID or cbc:ID/@schemeID = $TaxScheme4_schemeID or cbc:ID/@schemeID = $TaxScheme5_schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID/@schemeID = $TaxScheme_schemeID or cbc:ID/@schemeID = $TaxScheme2_schemeID or cbc:ID/@schemeID = $TaxScheme4_schemeID or cbc:ID/@schemeID = $TaxScheme5_schemeID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB070] Invalid schemeID. Must be either '<xsl:text />
            <xsl:value-of select="$TaxScheme_schemeID" />
            <xsl:text />', '<xsl:text />
            <xsl:value-of select="$TaxScheme2_schemeID" />
            <xsl:text />', '<xsl:text />
            <xsl:value-of select="$TaxScheme4_schemeID" />
            <xsl:text />' or '<xsl:text />
            <xsl:value-of select="$TaxScheme5_schemeID" />
            <xsl:text />'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:TaxTypeCode) and not((cbc:TaxTypeCode/@listID = $TaxType_listID) or (cbc:TaxTypeCode/@listID = $TaxType_listID2))">
      <svrl:successful-report test="(cbc:TaxTypeCode) and not((cbc:TaxTypeCode/@listID = $TaxType_listID) or (cbc:TaxTypeCode/@listID = $TaxType_listID2))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB071] Invalid listID. Must be either '<xsl:text />
          <xsl:value-of select="$TaxType_listID" />
          <xsl:text />' or '<xsl:text />
          <xsl:value-of select="$TaxType_listID2" />
          <xsl:text />'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID = '63') and cbc:Name != 'Moms'">
      <svrl:successful-report test="(cbc:ID = '63') and cbc:Name != 'Moms'">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB198] Name must equal 'Moms' when TaxScheme/ID equals '63' (Moms)</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID != '63') and cbc:Name = 'Moms'">
      <svrl:successful-report test="(cbc:ID != '63') and cbc:Name = 'Moms'">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB199] Name must correspond to the value of TaxScheme/ID</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cac:JurisdictionRegionAddress/cac:Country/cbc:IdentificationCode) and not(contains($CountryCode, concat(',',cac:JurisdictionRegionAddress/cac:Country/cbc:IdentificationCode,',')))">
      <svrl:successful-report test="(cac:JurisdictionRegionAddress/cac:Country/cbc:IdentificationCode) and not(contains($CountryCode, concat(',',cac:JurisdictionRegionAddress/cac:Country/cbc:IdentificationCode,',')))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB337] Invalid Country/IdentificationCode: '<xsl:text />
          <xsl:value-of select="cac:JurisdictionRegionAddress/cac:Country/cbc:IdentificationCode" />
          <xsl:text />'. Must be a value from the country codelist</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cac:JurisdictionRegionAddress) and cac:JurisdictionRegionAddress/cbc:AddressFormatCode != 'StructuredRegion'">
      <svrl:successful-report test="(cac:JurisdictionRegionAddress) and cac:JurisdictionRegionAddress/cbc:AddressFormatCode != 'StructuredRegion'">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB233] The AddressFormatCode under JurisdictionRegionAddress must always equal 'StructuredRegion'</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M20" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity" mode="M20" priority="1005">
    <svrl:fired-rule context="doc:Reminder/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:CorporateRegistrationScheme) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:CorporateRegistrationScheme) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB186] CorporateRegistrationScheme class must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:CompanyID) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:CompanyID) != ''">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB187] Invalid CompanyID. Must contain a value</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:CompanyID/@schemeID = 'DK:CVR' or cbc:CompanyID/@schemeID = 'DK:CPR' or cbc:CompanyID/@schemeID = 'ZZZ'" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:CompanyID/@schemeID = 'DK:CVR' or cbc:CompanyID/@schemeID = 'DK:CPR' or cbc:CompanyID/@schemeID = 'ZZZ'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB189] Invalid schemeID. Must be a valid scheme for PartyLegalEntity/CompanyID</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:CompanyID/@schemeID = 'DK:CVR') and (string-length(normalize-space(cbc:CompanyID)) != 10 or substring(cbc:CompanyID, 1, 2) != 'DK')">
      <svrl:successful-report test="(cbc:CompanyID/@schemeID = 'DK:CVR') and (string-length(normalize-space(cbc:CompanyID)) != 10 or substring(cbc:CompanyID, 1, 2) != 'DK')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB190] schemeID = DK:CVR, CompanyID must be a valid CVR number (like 'DK12345678', value found: '<xsl:text />
          <xsl:value-of select="cbc:CompanyID" />
          <xsl:text />')</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:CompanyID/@schemeID = 'DK:CPR') and not(string-length(cbc:CompanyID) = 10)">
      <svrl:successful-report test="(cbc:CompanyID/@schemeID = 'DK:CPR') and not(string-length(cbc:CompanyID) = 10)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB191] schemeID = DK:CPR, CompanyID must be a valid CPR number (like '1234560000', value found: '<xsl:text />
          <xsl:value-of select="cbc:CompanyID" />
          <xsl:text />')</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M20" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:AccountingCustomerParty/cac:Party/cac:Contact" mode="M20" priority="1004">
    <svrl:fired-rule context="doc:Reminder/cac:AccountingCustomerParty/cac:Party/cac:Contact" />

		<!--REPORT -->
<xsl:if test="(not(cbc:ID) or cbc:ID = '') and (not(cbc:Name) or cbc:Name = '') and (not(cbc:Telephone) or cbc:Telephone = '') and (not(cbc:Telefax) or cbc:Telefax = '') and (not(cbc:ElectronicMail) or cbc:ElectronicMail = '') and (not(cbc:Note) or cbc:Note = '') and not(cac:OtherCommunication)">
      <svrl:successful-report test="(not(cbc:ID) or cbc:ID = '') and (not(cbc:Name) or cbc:Name = '') and (not(cbc:Telephone) or cbc:Telephone = '') and (not(cbc:Telefax) or cbc:Telefax = '') and (not(cbc:ElectronicMail) or cbc:ElectronicMail = '') and (not(cbc:Note) or cbc:Note = '') and not(cac:OtherCommunication)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB235] At least one field in the Contact class should be specified</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:OtherCommunication/cbc:ChannelCode and cac:OtherCommunication/cbc:Channel">
      <svrl:successful-report test="cac:OtherCommunication/cbc:ChannelCode and cac:OtherCommunication/cbc:Channel">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB236] Use either ChannelCode or Channel</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:OtherCommunication and (normalize-space(cac:OtherCommunication/cbc:Value) = '')">
      <svrl:successful-report test="cac:OtherCommunication and (normalize-space(cac:OtherCommunication/cbc:Value) = '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB237] When Contact/OtherCommunication is used, the element Contact/OtherCommunication/Value must be filled out.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M20" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:AccountingCustomerParty/cac:Party/cac:Person" mode="M20" priority="1003">
    <svrl:fired-rule context="doc:Reminder/cac:AccountingCustomerParty/cac:Party/cac:Person" />

		<!--REPORT -->
<xsl:if test="(not(cbc:FamilyName) or cbc:FamilyName = '') and (not(cbc:FirstName) or cbc:FirstName = '')">
      <svrl:successful-report test="(not(cbc:FamilyName) or cbc:FamilyName = '') and (not(cbc:FirstName) or cbc:FirstName = '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB024] There must be a FirstName if the FamilyName is not present</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M20" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:AccountingCustomerParty/cac:DeliveryContact" mode="M20" priority="1002">
    <svrl:fired-rule context="doc:Reminder/cac:AccountingCustomerParty/cac:DeliveryContact" />

		<!--REPORT -->
<xsl:if test="(not(cbc:ID) or cbc:ID = '') and (not(cbc:Name) or cbc:Name = '') and (not(cbc:Telephone) or cbc:Telephone = '') and (not(cbc:Telefax) or cbc:Telefax = '') and (not(cbc:ElectronicMail) or cbc:ElectronicMail = '') and (not(cbc:Note) or cbc:Note = '') and not(cac:OtherCommunication)">
      <svrl:successful-report test="(not(cbc:ID) or cbc:ID = '') and (not(cbc:Name) or cbc:Name = '') and (not(cbc:Telephone) or cbc:Telephone = '') and (not(cbc:Telefax) or cbc:Telefax = '') and (not(cbc:ElectronicMail) or cbc:ElectronicMail = '') and (not(cbc:Note) or cbc:Note = '') and not(cac:OtherCommunication)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB235] At least one field in the Contact class should be specified</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:OtherCommunication/cbc:ChannelCode and cac:OtherCommunication/cbc:Channel">
      <svrl:successful-report test="cac:OtherCommunication/cbc:ChannelCode and cac:OtherCommunication/cbc:Channel">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB236] Use either ChannelCode or Channel</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:OtherCommunication and (normalize-space(cac:OtherCommunication/cbc:Value) = '')">
      <svrl:successful-report test="cac:OtherCommunication and (normalize-space(cac:OtherCommunication/cbc:Value) = '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB237] When Contact/OtherCommunication is used, the element Contact/OtherCommunication/Value must be filled out.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M20" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:AccountingCustomerParty/cac:AccountingContact" mode="M20" priority="1001">
    <svrl:fired-rule context="doc:Reminder/cac:AccountingCustomerParty/cac:AccountingContact" />

		<!--REPORT -->
<xsl:if test="(not(cbc:ID) or cbc:ID = '') and (not(cbc:Name) or cbc:Name = '') and (not(cbc:Telephone) or cbc:Telephone = '') and (not(cbc:Telefax) or cbc:Telefax = '') and (not(cbc:ElectronicMail) or cbc:ElectronicMail = '') and (not(cbc:Note) or cbc:Note = '') and not(cac:OtherCommunication)">
      <svrl:successful-report test="(not(cbc:ID) or cbc:ID = '') and (not(cbc:Name) or cbc:Name = '') and (not(cbc:Telephone) or cbc:Telephone = '') and (not(cbc:Telefax) or cbc:Telefax = '') and (not(cbc:ElectronicMail) or cbc:ElectronicMail = '') and (not(cbc:Note) or cbc:Note = '') and not(cac:OtherCommunication)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB235] At least one field in the Contact class should be specified</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:OtherCommunication/cbc:ChannelCode and cac:OtherCommunication/cbc:Channel">
      <svrl:successful-report test="cac:OtherCommunication/cbc:ChannelCode and cac:OtherCommunication/cbc:Channel">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB236] Use either ChannelCode or Channel</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:OtherCommunication and (normalize-space(cac:OtherCommunication/cbc:Value) = '')">
      <svrl:successful-report test="cac:OtherCommunication and (normalize-space(cac:OtherCommunication/cbc:Value) = '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB237] When Contact/OtherCommunication is used, the element Contact/OtherCommunication/Value must be filled out.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M20" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:AccountingCustomerParty/cac:BuyerContact" mode="M20" priority="1000">
    <svrl:fired-rule context="doc:Reminder/cac:AccountingCustomerParty/cac:BuyerContact" />

		<!--REPORT -->
<xsl:if test="(not(cbc:ID) or cbc:ID = '') and (not(cbc:Name) or cbc:Name = '') and (not(cbc:Telephone) or cbc:Telephone = '') and (not(cbc:Telefax) or cbc:Telefax = '') and (not(cbc:ElectronicMail) or cbc:ElectronicMail = '') and (not(cbc:Note) or cbc:Note = '') and not(cac:OtherCommunication)">
      <svrl:successful-report test="(not(cbc:ID) or cbc:ID = '') and (not(cbc:Name) or cbc:Name = '') and (not(cbc:Telephone) or cbc:Telephone = '') and (not(cbc:Telefax) or cbc:Telefax = '') and (not(cbc:ElectronicMail) or cbc:ElectronicMail = '') and (not(cbc:Note) or cbc:Note = '') and not(cac:OtherCommunication)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB235] At least one field in the Contact class should be specified</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:OtherCommunication/cbc:ChannelCode and cac:OtherCommunication/cbc:Channel">
      <svrl:successful-report test="cac:OtherCommunication/cbc:ChannelCode and cac:OtherCommunication/cbc:Channel">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB236] Use either ChannelCode or Channel</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:OtherCommunication and (normalize-space(cac:OtherCommunication/cbc:Value) = '')">
      <svrl:successful-report test="cac:OtherCommunication and (normalize-space(cac:OtherCommunication/cbc:Value) = '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB237] When Contact/OtherCommunication is used, the element Contact/OtherCommunication/Value must be filled out.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M20" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M20" priority="-1" />
  <xsl:template match="@*|node()" mode="M20" priority="-2">
    <xsl:apply-templates mode="M20" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN payeeparty-->


	<!--RULE -->
<xsl:template match="doc:Reminder/cac:PayeeParty" mode="M21" priority="1012">
    <svrl:fired-rule context="doc:Reminder/cac:PayeeParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:MarkCareIndicator) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:MarkCareIndicator) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB166] MarkCareIndicator element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:MarkAttentionIndicator) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:MarkAttentionIndicator) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB167] MarkAttentionIndicator element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:AgentParty) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:AgentParty) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB168] AgentParty class must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:EndpointID) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:EndpointID) != ''">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-REM034] Invalid EndpointID. Must contain a value</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="(not(cac:PartyIdentification) or cac:PartyIdentification/cbc:ID = '') and (not(cac:PartyName) or cac:PartyName/cbc:Name = '')">
      <svrl:successful-report test="(not(cac:PartyIdentification) or cac:PartyIdentification/cbc:ID = '') and (not(cac:PartyName) or cac:PartyName/cbc:Name = '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB022] PartyName/Name is mandatory if PartyIdentification/ID is not found</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:EndpointID and not(contains($EndpointID_schemeID, concat(',',cbc:EndpointID/@schemeID,',')))">
      <svrl:successful-report test="cbc:EndpointID and not(contains($EndpointID_schemeID, concat(',',cbc:EndpointID/@schemeID,',')))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB179] Invalid schemeID: '<xsl:text />
          <xsl:value-of select="cbc:EndpointID/@schemeID" />
          <xsl:text />'. Must be a value from the codelist: '<xsl:text />
          <xsl:value-of select="$EndpointID_schemeID" />
          <xsl:text />'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:EndpointID/@schemeID = 'DK:CVR') and (string-length(cbc:EndpointID) != 10 or substring(cbc:EndpointID, 1, 2) != 'DK')">
      <svrl:successful-report test="(cbc:EndpointID/@schemeID = 'DK:CVR') and (string-length(cbc:EndpointID) != 10 or substring(cbc:EndpointID, 1, 2) != 'DK')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB180] schemeID = DK:CVR, EndpointID must be a valid CVR number (like 'DK12345678', value found: '<xsl:text />
          <xsl:value-of select="cbc:EndpointID" />
          <xsl:text />')</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:EndpointID/@schemeID = 'DK:CPR') and not(string-length(cbc:EndpointID) = 10)">
      <svrl:successful-report test="(cbc:EndpointID/@schemeID = 'DK:CPR') and not(string-length(cbc:EndpointID) = 10)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB215] schemeID = DK:CPR, EndpointID must be a valid CPR number (like '1234560000', value found: '<xsl:text />
          <xsl:value-of select="cbc:EndpointID" />
          <xsl:text />')</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:EndpointID/@schemeID = 'GLN') and not(string-length(cbc:EndpointID) = 13)">
      <svrl:successful-report test="(cbc:EndpointID/@schemeID = 'GLN') and not(string-length(cbc:EndpointID) = 13)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB181] schemeID = GLN, EndpointID must be a valid GLN number (like '1234567890123', value found: '<xsl:text />
          <xsl:value-of select="cbc:EndpointID" />
          <xsl:text />')</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:EndpointID/@schemeID = 'EAN') and not(string-length(cbc:EndpointID) = 13)">
      <svrl:successful-report test="(cbc:EndpointID/@schemeID = 'EAN') and not(string-length(cbc:EndpointID) = 13)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB216] schemeID = EAN, EndpointID must be a valid EAN number (like '1234567890123', value found: '<xsl:text />
          <xsl:value-of select="cbc:EndpointID" />
          <xsl:text />')</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="count(cac:PartyLegalEntity) > 1">
      <svrl:successful-report test="count(cac:PartyLegalEntity) > 1">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-REM072] No more than one PartyLegalEntity class may be present</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M21" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:PayeeParty/cac:PartyIdentification" mode="M21" priority="1011">
    <svrl:fired-rule context="doc:Reminder/cac:PayeeParty/cac:PartyIdentification" />

		<!--REPORT -->
<xsl:if test="not(contains($PartyID_schemeID, concat(',',cbc:ID/@schemeID,',')))">
      <svrl:successful-report test="not(contains($PartyID_schemeID, concat(',',cbc:ID/@schemeID,',')))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB183] Invalid schemeID: '<xsl:text />
          <xsl:value-of select="cbc:ID/@schemeID" />
          <xsl:text />'. Must be a value from the codelist: '<xsl:text />
          <xsl:value-of select="$PartyID_schemeID" />
          <xsl:text />'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID/@schemeID = 'DK:CVR') and (string-length(cbc:ID) != 10 or substring(cbc:ID, 1, 2) != 'DK')">
      <svrl:successful-report test="(cbc:ID/@schemeID = 'DK:CVR') and (string-length(cbc:ID) != 10 or substring(cbc:ID, 1, 2) != 'DK')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB184] schemeID = DK:CVR, ID must be a valid CVR number (like 'DK12345678', value found: '<xsl:text />
          <xsl:value-of select="cbc:ID" />
          <xsl:text />')</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID/@schemeID = 'DK:CPR') and not(string-length(cbc:ID) = 10)">
      <svrl:successful-report test="(cbc:ID/@schemeID = 'DK:CPR') and not(string-length(cbc:ID) = 10)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB217] schemeID = DK:CPR, ID must be a valid CPR number (like '1234560000', value found: '<xsl:text />
          <xsl:value-of select="cbc:ID" />
          <xsl:text />')</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID/@schemeID = 'GLN') and not(string-length(cbc:ID) = 13)">
      <svrl:successful-report test="(cbc:ID/@schemeID = 'GLN') and not(string-length(cbc:ID) = 13)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB185] schemeID = GLN, ID must be a valid GLN number (like '1234567890123', value found: '<xsl:text />
          <xsl:value-of select="cbc:ID" />
          <xsl:text />')</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID/@schemeID = 'EAN') and not(string-length(cbc:ID) = 13)">
      <svrl:successful-report test="(cbc:ID/@schemeID = 'EAN') and not(string-length(cbc:ID) = 13)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB218] schemeID = EAN, ID must be a valid EAN number (like '1234567890123', value found: '<xsl:text />
          <xsl:value-of select="cbc:ID" />
          <xsl:text />')</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID/@schemeID = 'DK:P') and not(string-length(cbc:ID) = 10)">
      <svrl:successful-report test="(cbc:ID/@schemeID = 'DK:P') and not(string-length(cbc:ID) = 10)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB287] schemeID = DK:P, ID must be a valid P number (like '1234567890', value found: '<xsl:text />
          <xsl:value-of select="cbc:ID" />
          <xsl:text />')</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M21" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:PayeeParty/cac:PartyName" mode="M21" priority="1010">
    <svrl:fired-rule context="doc:Reminder/cac:PayeeParty/cac:PartyName" />

		<!--REPORT -->
<xsl:if test="count(../cac:PartyName) > 1 and not(./cbc:Name/@languageID)">
      <svrl:successful-report test="count(../cac:PartyName) > 1 and not(./cbc:Name/@languageID)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[W-LIB219] The attribute Name@languageID should be used when more than one PartyName class is present</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="local-name(following-sibling::*) = local-name(current()) and following-sibling::*/cbc:Name/@languageID = self::*/cbc:Name/@languageID">
      <svrl:successful-report test="local-name(following-sibling::*) = local-name(current()) and following-sibling::*/cbc:Name/@languageID = self::*/cbc:Name/@languageID">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[W-LIB220] Multilanguage error. Replicated PartyName classes with same Name@languageID attribute value</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M21" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:PayeeParty/cac:PostalAddress" mode="M21" priority="1009">
    <svrl:fired-rule context="doc:Reminder/cac:PayeeParty/cac:PostalAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:BlockName) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:BlockName) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB210] BlockName element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:TimezoneOffset) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:TimezoneOffset) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB211] TimezoneOffset element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:LocationCoordinate) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:LocationCoordinate) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB212] LocationCoordinate class must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:AddressFormatCode) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:AddressFormatCode) != ''">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB025] Invalid AddressFormatCode. Must contain a value</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listID = 'urn:oioubl:codelist:addresstypecode-1.1')">
      <svrl:successful-report test="cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listID = 'urn:oioubl:codelist:addresstypecode-1.1')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB204] Invalid listID. Must be 'urn:oioubl:codelist:addresstypecode-1.1'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listAgencyID = '320')">
      <svrl:successful-report test="cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listAgencyID = '320')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB205] Invalid listAgencyID. Must be '320'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode = 'Home' or cbc:AddressTypeCode = 'Business' )">
      <svrl:successful-report test="cbc:AddressTypeCode and not(cbc:AddressTypeCode = 'Home' or cbc:AddressTypeCode = 'Business' )">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB206] Invalid AddressTypeCode. Must be a value from the codelist</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:AddressFormatCode/@listID = 'urn:oioubl:codelist:addressformatcode-1.1' or cbc:AddressFormatCode/@listID = 'UN/ECE 3477'" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:AddressFormatCode/@listID = 'urn:oioubl:codelist:addressformatcode-1.1' or cbc:AddressFormatCode/@listID = 'UN/ECE 3477'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB026] Invalid listID. Must be either 'urn:oioubl:codelist:addressformatcode-1.1' or 'UN/ECE 3477'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'urn:oioubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode/@listAgencyID = '320')">
      <svrl:successful-report test="cbc:AddressFormatCode/@listID = 'urn:oioubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode/@listAgencyID = '320')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB207] Invalid listAgencyID. Must be '320'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'urn:oioubl:codelist:addressformatcode-1.1' and not(normalize-space(cbc:AddressFormatCode) = 'StructuredDK' or normalize-space(cbc:AddressFormatCode) = 'StructuredLax' or normalize-space(cbc:AddressFormatCode) = 'StructuredID' or normalize-space(cbc:AddressFormatCode) = 'StructuredRegion' or normalize-space(cbc:AddressFormatCode) = 'Unstructured')">
      <svrl:successful-report test="cbc:AddressFormatCode/@listID = 'urn:oioubl:codelist:addressformatcode-1.1' and not(normalize-space(cbc:AddressFormatCode) = 'StructuredDK' or normalize-space(cbc:AddressFormatCode) = 'StructuredLax' or normalize-space(cbc:AddressFormatCode) = 'StructuredID' or normalize-space(cbc:AddressFormatCode) = 'StructuredRegion' or normalize-space(cbc:AddressFormatCode) = 'Unstructured')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB027] Invalid AddressFormatCode. Must be a value from the codelist</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode/@listAgencyID = '6')">
      <svrl:successful-report test="cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode/@listAgencyID = '6')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB208] Invalid listAgencyID. Must be '6'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode = '1' or cbc:AddressFormatCode = '2' or cbc:AddressFormatCode = '3' or cbc:AddressFormatCode = '4' or cbc:AddressFormatCode = '5' or cbc:AddressFormatCode = '6' or cbc:AddressFormatCode = '7' or cbc:AddressFormatCode = '8' or cbc:AddressFormatCode = '9')">
      <svrl:successful-report test="cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode = '1' or cbc:AddressFormatCode = '2' or cbc:AddressFormatCode = '3' or cbc:AddressFormatCode = '4' or cbc:AddressFormatCode = '5' or cbc:AddressFormatCode = '6' or cbc:AddressFormatCode = '7' or cbc:AddressFormatCode = '8' or cbc:AddressFormatCode = '9')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB209] Invalid AddressFormatCode. Must be a value from the codelist</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Country and not(cac:Country/cbc:IdentificationCode != '')">
      <svrl:successful-report test="cac:Country and not(cac:Country/cbc:IdentificationCode != '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB213] When Country is used, the element Country/IdentificationCode must be filled out</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'Unstructured') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'Unstructured') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB031] An Unstructured address is only allowed to have AddressLine elements</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and cac:AddressLine">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'StructuredDK') and cac:AddressLine">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB032] AddressLine elements not allowed for a StructuredDK address type</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and (not(cbc:PostalZone) or normalize-space(cbc:PostalZone) = '')">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'StructuredDK') and (not(cbc:PostalZone) or normalize-space(cbc:PostalZone) = '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB033] PostalZone is mandatory for a StructuredDK address type</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:StreetName) or normalize-space(cbc:StreetName) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:StreetName) or normalize-space(cbc:StreetName) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB034] There should be either a StreetName or a Postbox for a StructuredDK address type</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:BuildingNumber) or normalize-space(cbc:BuildingNumber) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:BuildingNumber) or normalize-space(cbc:BuildingNumber) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB035] There should be either a BuildingNumber or a Postbox for a StructuredDK address type</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredLax') and cac:AddressLine">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'StructuredLax') and cac:AddressLine">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB036] AddressLine elements not allowed for a StructuredLax address type</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredID') and (not(cbc:ID) or cbc:ID = '')">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'StructuredID') and (not(cbc:ID) or cbc:ID = '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB037] ID is required for a StructuredID address type</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredID') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'StructuredID') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB038] Only the ID is used for a StructuredID address type</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredRegion') and ((not(cac:Country/cbc:IdentificationCode) or cac:Country/cbc:IdentificationCode = '') and (not(cbc:Region) or cbc:Region = '') and (not(cbc:District) or cbc:District = ''))">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'StructuredRegion') and ((not(cac:Country/cbc:IdentificationCode) or cac:Country/cbc:IdentificationCode = '') and (not(cbc:Region) or cbc:Region = '') and (not(cbc:District) or cbc:District = ''))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB039] Region or District or Country/IdentificationCode is required for a StructuredRegion address type</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredRegion') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0')">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'StructuredRegion') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB040] Only Region, District, and/or Country/IdentificationCode can be used for a StructuredRegion address type</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:ID and not(string-length(cbc:ID/@schemeID)>0)">
      <svrl:successful-report test="cbc:ID and not(string-length(cbc:ID/@schemeID)>0)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB028] When ID is used under Address the attribute schemeID is used to give an addressregister</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:ID and not(cbc:ID/@schemeID)">
      <svrl:successful-report test="cbc:ID and not(cbc:ID/@schemeID)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB029] schemeID attribute must be present on an address ID</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Country/cbc:IdentificationCode and not(contains($CountryCode, concat(',',cac:Country/cbc:IdentificationCode,',')))">
      <svrl:successful-report test="cac:Country/cbc:IdentificationCode and not(contains($CountryCode, concat(',',cac:Country/cbc:IdentificationCode,',')))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB301] Invalid Country/IdentificationCode: '<xsl:text />
          <xsl:value-of select="cac:Country/cbc:IdentificationCode" />
          <xsl:text />'. Must be a value from the codelist</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M21" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:PayeeParty/cac:PhysicalLocation" mode="M21" priority="1008">
    <svrl:fired-rule context="doc:Reminder/cac:PayeeParty/cac:PhysicalLocation" />

		<!--REPORT -->
<xsl:if test="(not(cbc:ID) or cbc:ID = '') and (count(cac:Address) = 0)">
      <svrl:successful-report test="(not(cbc:ID) or cbc:ID = '') and (count(cac:Address) = 0)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB221] If ID not specified, Address is mandatory</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M21" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:PayeeParty/cac:PhysicalLocation/cac:ValidityPeriod" mode="M21" priority="1007">
    <svrl:fired-rule context="doc:Reminder/cac:PayeeParty/cac:PhysicalLocation/cac:ValidityPeriod" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:DurationMeasure) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:DurationMeasure) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB076] DurationMeasure element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:DescriptionCode) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:DescriptionCode) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB077] DescriptionCode element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:StartTime) and (not(cbc:StartDate) or cbc:StartDate = '')">
      <svrl:successful-report test="(cbc:StartTime) and (not(cbc:StartDate) or cbc:StartDate = '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB078] There must be a StartDate if you have a StartTime</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:EndTime) and (not(cbc:EndDate) or cbc:EndDate = '')">
      <svrl:successful-report test="(cbc:EndTime) and (not(cbc:EndDate) or cbc:EndDate = '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB079] There must be a EndDate if you have a EndTime</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:StartDate and cbc:EndDate) and not(number(translate(cbc:EndDate,'-','')) > number(translate(cbc:StartDate,'-','')) or number(translate(cbc:EndDate,'-','')) = number(translate(cbc:StartDate,'-','')))">
      <svrl:successful-report test="(cbc:StartDate and cbc:EndDate) and not(number(translate(cbc:EndDate,'-','')) > number(translate(cbc:StartDate,'-','')) or number(translate(cbc:EndDate,'-','')) = number(translate(cbc:StartDate,'-','')))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB080] The EndDate must be greater or equal to the startdate</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:StartTime and cbc:EndTime) and not(number(translate(cbc:EndTime,':','')) > number(translate(cbc:StartTime,':','')) or number(translate(cbc:EndTime,':','')) = number(translate(cbc:StartTime,':','')))">
      <svrl:successful-report test="(cbc:StartTime and cbc:EndTime) and not(number(translate(cbc:EndTime,':','')) > number(translate(cbc:StartTime,':','')) or number(translate(cbc:EndTime,':','')) = number(translate(cbc:StartTime,':','')))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB081] EndTime must be greater or equal to StartTime</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M21" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:PayeeParty/cac:PhysicalLocation/cac:ValidityPeriod/cbc:Description" mode="M21" priority="1006">
    <svrl:fired-rule context="doc:Reminder/cac:PayeeParty/cac:PhysicalLocation/cac:ValidityPeriod/cbc:Description" />

		<!--REPORT -->
<xsl:if test="count(../cbc:Description) > 1 and not(./@languageID)">
      <svrl:successful-report test="count(../cbc:Description) > 1 and not(./@languageID)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[W-LIB222] The attribute languageID should be used when more than one Description element is present</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID">
      <svrl:successful-report test="local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[W-LIB223] Multilanguage error. Replicated Description elements with same languageID attribute value</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M21" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:PayeeParty/cac:PhysicalLocation/cac:Address" mode="M21" priority="1005">
    <svrl:fired-rule context="doc:Reminder/cac:PayeeParty/cac:PhysicalLocation/cac:Address" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:BlockName) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:BlockName) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB210] BlockName element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:TimezoneOffset) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:TimezoneOffset) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB211] TimezoneOffset element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:LocationCoordinate) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:LocationCoordinate) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB212] LocationCoordinate class must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:AddressFormatCode) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:AddressFormatCode) != ''">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB025] Invalid AddressFormatCode. Must contain a value</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listID = 'urn:oioubl:codelist:addresstypecode-1.1')">
      <svrl:successful-report test="cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listID = 'urn:oioubl:codelist:addresstypecode-1.1')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB204] Invalid listID. Must be 'urn:oioubl:codelist:addresstypecode-1.1'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listAgencyID = '320')">
      <svrl:successful-report test="cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listAgencyID = '320')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB205] Invalid listAgencyID. Must be '320'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode = 'Home' or cbc:AddressTypeCode = 'Business' )">
      <svrl:successful-report test="cbc:AddressTypeCode and not(cbc:AddressTypeCode = 'Home' or cbc:AddressTypeCode = 'Business' )">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB206] Invalid AddressTypeCode. Must be a value from the codelist</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:AddressFormatCode/@listID = 'urn:oioubl:codelist:addressformatcode-1.1' or cbc:AddressFormatCode/@listID = 'UN/ECE 3477'" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:AddressFormatCode/@listID = 'urn:oioubl:codelist:addressformatcode-1.1' or cbc:AddressFormatCode/@listID = 'UN/ECE 3477'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB026] Invalid listID. Must be either 'urn:oioubl:codelist:addressformatcode-1.1' or 'UN/ECE 3477'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'urn:oioubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode/@listAgencyID = '320')">
      <svrl:successful-report test="cbc:AddressFormatCode/@listID = 'urn:oioubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode/@listAgencyID = '320')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB207] Invalid listAgencyID. Must be '320'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'urn:oioubl:codelist:addressformatcode-1.1' and not(normalize-space(cbc:AddressFormatCode) = 'StructuredDK' or normalize-space(cbc:AddressFormatCode) = 'StructuredLax' or normalize-space(cbc:AddressFormatCode) = 'StructuredID' or normalize-space(cbc:AddressFormatCode) = 'StructuredRegion' or normalize-space(cbc:AddressFormatCode) = 'Unstructured')">
      <svrl:successful-report test="cbc:AddressFormatCode/@listID = 'urn:oioubl:codelist:addressformatcode-1.1' and not(normalize-space(cbc:AddressFormatCode) = 'StructuredDK' or normalize-space(cbc:AddressFormatCode) = 'StructuredLax' or normalize-space(cbc:AddressFormatCode) = 'StructuredID' or normalize-space(cbc:AddressFormatCode) = 'StructuredRegion' or normalize-space(cbc:AddressFormatCode) = 'Unstructured')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB027] Invalid AddressFormatCode. Must be a value from the codelist</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode/@listAgencyID = '6')">
      <svrl:successful-report test="cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode/@listAgencyID = '6')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB208] Invalid listAgencyID. Must be '6'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode = '1' or cbc:AddressFormatCode = '2' or cbc:AddressFormatCode = '3' or cbc:AddressFormatCode = '4' or cbc:AddressFormatCode = '5' or cbc:AddressFormatCode = '6' or cbc:AddressFormatCode = '7' or cbc:AddressFormatCode = '8' or cbc:AddressFormatCode = '9')">
      <svrl:successful-report test="cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode = '1' or cbc:AddressFormatCode = '2' or cbc:AddressFormatCode = '3' or cbc:AddressFormatCode = '4' or cbc:AddressFormatCode = '5' or cbc:AddressFormatCode = '6' or cbc:AddressFormatCode = '7' or cbc:AddressFormatCode = '8' or cbc:AddressFormatCode = '9')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB209] Invalid AddressFormatCode. Must be a value from the codelist</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Country and not(cac:Country/cbc:IdentificationCode != '')">
      <svrl:successful-report test="cac:Country and not(cac:Country/cbc:IdentificationCode != '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB213] When Country is used, the element Country/IdentificationCode must be filled out</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'Unstructured') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'Unstructured') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB031] An Unstructured address is only allowed to have AddressLine elements</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and cac:AddressLine">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'StructuredDK') and cac:AddressLine">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB032] AddressLine elements not allowed for a StructuredDK address type</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and (not(cbc:PostalZone) or normalize-space(cbc:PostalZone) = '')">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'StructuredDK') and (not(cbc:PostalZone) or normalize-space(cbc:PostalZone) = '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB033] PostalZone is mandatory for a StructuredDK address type</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:StreetName) or normalize-space(cbc:StreetName) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:StreetName) or normalize-space(cbc:StreetName) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB034] There should be either a StreetName or a Postbox for a StructuredDK address type</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:BuildingNumber) or normalize-space(cbc:BuildingNumber) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:BuildingNumber) or normalize-space(cbc:BuildingNumber) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB035] There should be either a BuildingNumber or a Postbox for a StructuredDK address type</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredLax') and cac:AddressLine">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'StructuredLax') and cac:AddressLine">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB036] AddressLine elements not allowed for a StructuredLax address type</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredID') and (not(cbc:ID) or cbc:ID = '')">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'StructuredID') and (not(cbc:ID) or cbc:ID = '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB037] ID is required for a StructuredID address type</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredID') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'StructuredID') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB038] Only the ID is used for a StructuredID address type</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredRegion') and ((not(cac:Country/cbc:IdentificationCode) or cac:Country/cbc:IdentificationCode = '') and (not(cbc:Region) or cbc:Region = '') and (not(cbc:District) or cbc:District = ''))">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'StructuredRegion') and ((not(cac:Country/cbc:IdentificationCode) or cac:Country/cbc:IdentificationCode = '') and (not(cbc:Region) or cbc:Region = '') and (not(cbc:District) or cbc:District = ''))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB039] Region or District or Country/IdentificationCode is required for a StructuredRegion address type</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredRegion') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0')">
      <svrl:successful-report test="(cbc:AddressFormatCode = 'StructuredRegion') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB040] Only Region, District, and/or Country/IdentificationCode can be used for a StructuredRegion address type</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:ID and not(string-length(cbc:ID/@schemeID)>0)">
      <svrl:successful-report test="cbc:ID and not(string-length(cbc:ID/@schemeID)>0)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB028] When ID is used under Address the attribute schemeID is used to give an addressregister</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:ID and not(cbc:ID/@schemeID)">
      <svrl:successful-report test="cbc:ID and not(cbc:ID/@schemeID)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB029] schemeID attribute must be present on an address ID</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Country/cbc:IdentificationCode and not(contains($CountryCode, concat(',',cac:Country/cbc:IdentificationCode,',')))">
      <svrl:successful-report test="cac:Country/cbc:IdentificationCode and not(contains($CountryCode, concat(',',cac:Country/cbc:IdentificationCode,',')))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB301] Invalid Country/IdentificationCode: '<xsl:text />
          <xsl:value-of select="cac:Country/cbc:IdentificationCode" />
          <xsl:text />'. Must be a value from the codelist</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M21" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:PayeeParty/cac:PartyTaxScheme" mode="M21" priority="1004">
    <svrl:fired-rule context="doc:Reminder/cac:PayeeParty/cac:PartyTaxScheme" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:TaxLevelCode) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:TaxLevelCode) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB192] TaxLevelCode element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:CompanyID) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:CompanyID) != ''">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB193] Invalid CompanyID. Must contain a value</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:CompanyID/@schemeID = 'DK:SE' or cbc:CompanyID/@schemeID = 'ZZZ' " />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:CompanyID/@schemeID = 'DK:SE' or cbc:CompanyID/@schemeID = 'ZZZ'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB195] Invalid schemeID. Must be a valid scheme for PartyTaxScheme/CompanyID</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:CompanyID/@schemeID = 'DK:SE') and (string-length(normalize-space(cbc:CompanyID)) != 10 or substring(cbc:CompanyID, 1, 2) != 'DK')">
      <svrl:successful-report test="(cbc:CompanyID/@schemeID = 'DK:SE') and (string-length(normalize-space(cbc:CompanyID)) != 10 or substring(cbc:CompanyID, 1, 2) != 'DK')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB196] schemeID = DK:SE, CompanyID must be a valid SE number (like 'DK12345678', value found: '<xsl:text />
          <xsl:value-of select="cbc:CompanyID" />
          <xsl:text />')</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M21" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:PayeeParty/cac:PartyTaxScheme/cac:TaxScheme" mode="M21" priority="1003">
    <svrl:fired-rule context="doc:Reminder/cac:PayeeParty/cac:PartyTaxScheme/cac:TaxScheme" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:ID) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:ID) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB041] ID element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:AddressTypeCode) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:AddressTypeCode) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB042] AddressTypeCode element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:Postbox) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:Postbox) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB043] Postbox element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:Floor) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:Floor) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB044] Floor element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:Room) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:Room) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB045] Room element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:StreetName) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:StreetName) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB046] StreetName element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:AdditionalStreetName) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:AdditionalStreetName) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB047] AdditionalStreetName element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:BlockName) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:BlockName) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB048] BlockName element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:BuildingName) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:BuildingName) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB049] BuildingName element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:BuildingNumber) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:BuildingNumber) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB050] BuildingNumber element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:InhouseMail) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:InhouseMail) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB051] InhouseMail element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:Department) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:Department) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB052] Department element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:MarkAttention) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:MarkAttention) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB053] MarkAttention element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:MarkCare) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:MarkCare) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB054] MarkCare element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:PlotIdentification) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:PlotIdentification) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB055] PlotIdentification element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:CitySubdivisionName) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:CitySubdivisionName) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB056] CitySubdivisionName element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:CityName) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:CityName) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB057] CityName element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:PostalZone) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:PostalZone) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB058] PostalZone element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:CountrySubentity) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:CountrySubentity) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB059] CountrySubentity element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:CountrySubentityCode) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:CountrySubentityCode) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB060] CountrySubentityCode element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:TimezoneOffset) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:TimezoneOffset) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB063] TimezoneOffset element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cac:AddressLine) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cac:AddressLine) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB234] AddressLine class must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cac:LocationCoordinate) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cac:LocationCoordinate) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB064] LocationCoordinate class must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:ID = '63') and cbc:TaxTypeCode">
      <svrl:successful-report test="(cbc:ID = '63') and cbc:TaxTypeCode">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB067] TaxTypeCode is not allowed when TaxScheme/ID equals '63' (Moms)</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:ID) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:ID) != ''">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB065] Invalid TaxScheme/ID. Must contain a value.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:Name) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:Name) != ''">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB066] Invalid Name. Must contain a value</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="not((cbc:ID = '63' or cbc:ID = 'VAT')) and not(contains($TaxType2, concat(',',cbc:TaxTypeCode,',')))">
      <svrl:successful-report test="not((cbc:ID = '63' or cbc:ID = 'VAT')) and not(contains($TaxType2, concat(',',cbc:TaxTypeCode,',')))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB197] TaxTypeCode must be a value from the '<xsl:text />
          <xsl:value-of select="$TaxType_listID2" />
          <xsl:text />' codelist when TaxScheme/ID is different from '63' or 'VAT' (Moms)</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID/@schemeID = $TaxScheme_schemeID or cbc:ID/@schemeID = $TaxScheme2_schemeID or cbc:ID/@schemeID = $TaxScheme4_schemeID or cbc:ID/@schemeID = $TaxScheme5_schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID/@schemeID = $TaxScheme_schemeID or cbc:ID/@schemeID = $TaxScheme2_schemeID or cbc:ID/@schemeID = $TaxScheme4_schemeID or cbc:ID/@schemeID = $TaxScheme5_schemeID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB070] Invalid schemeID. Must be either '<xsl:text />
            <xsl:value-of select="$TaxScheme_schemeID" />
            <xsl:text />', '<xsl:text />
            <xsl:value-of select="$TaxScheme2_schemeID" />
            <xsl:text />', '<xsl:text />
            <xsl:value-of select="$TaxScheme4_schemeID" />
            <xsl:text />' or '<xsl:text />
            <xsl:value-of select="$TaxScheme5_schemeID" />
            <xsl:text />'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:TaxTypeCode) and not((cbc:TaxTypeCode/@listID = $TaxType_listID) or (cbc:TaxTypeCode/@listID = $TaxType_listID2))">
      <svrl:successful-report test="(cbc:TaxTypeCode) and not((cbc:TaxTypeCode/@listID = $TaxType_listID) or (cbc:TaxTypeCode/@listID = $TaxType_listID2))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB071] Invalid listID. Must be either '<xsl:text />
          <xsl:value-of select="$TaxType_listID" />
          <xsl:text />' or '<xsl:text />
          <xsl:value-of select="$TaxType_listID2" />
          <xsl:text />'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID = '63') and cbc:Name != 'Moms'">
      <svrl:successful-report test="(cbc:ID = '63') and cbc:Name != 'Moms'">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB198] Name must equal 'Moms' when TaxScheme/ID equals '63' (Moms)</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID != '63') and cbc:Name = 'Moms'">
      <svrl:successful-report test="(cbc:ID != '63') and cbc:Name = 'Moms'">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB199] Name must correspond to the value of TaxScheme/ID</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cac:JurisdictionRegionAddress/cac:Country/cbc:IdentificationCode) and not(contains($CountryCode, concat(',',cac:JurisdictionRegionAddress/cac:Country/cbc:IdentificationCode,',')))">
      <svrl:successful-report test="(cac:JurisdictionRegionAddress/cac:Country/cbc:IdentificationCode) and not(contains($CountryCode, concat(',',cac:JurisdictionRegionAddress/cac:Country/cbc:IdentificationCode,',')))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB337] Invalid Country/IdentificationCode: '<xsl:text />
          <xsl:value-of select="cac:JurisdictionRegionAddress/cac:Country/cbc:IdentificationCode" />
          <xsl:text />'. Must be a value from the country codelist</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cac:JurisdictionRegionAddress) and cac:JurisdictionRegionAddress/cbc:AddressFormatCode != 'StructuredRegion'">
      <svrl:successful-report test="(cac:JurisdictionRegionAddress) and cac:JurisdictionRegionAddress/cbc:AddressFormatCode != 'StructuredRegion'">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB233] The AddressFormatCode under JurisdictionRegionAddress must always equal 'StructuredRegion'</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M21" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:PayeeParty/cac:PartyLegalEntity" mode="M21" priority="1002">
    <svrl:fired-rule context="doc:Reminder/cac:PayeeParty/cac:PartyLegalEntity" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:CorporateRegistrationScheme) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:CorporateRegistrationScheme) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB186] CorporateRegistrationScheme class must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:CompanyID) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:CompanyID) != ''">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB187] Invalid CompanyID. Must contain a value</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:CompanyID/@schemeID = 'DK:CVR' or cbc:CompanyID/@schemeID = 'DK:CPR' or cbc:CompanyID/@schemeID = 'ZZZ'" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:CompanyID/@schemeID = 'DK:CVR' or cbc:CompanyID/@schemeID = 'DK:CPR' or cbc:CompanyID/@schemeID = 'ZZZ'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB189] Invalid schemeID. Must be a valid scheme for PartyLegalEntity/CompanyID</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:CompanyID/@schemeID = 'DK:CVR') and (string-length(normalize-space(cbc:CompanyID)) != 10 or substring(cbc:CompanyID, 1, 2) != 'DK')">
      <svrl:successful-report test="(cbc:CompanyID/@schemeID = 'DK:CVR') and (string-length(normalize-space(cbc:CompanyID)) != 10 or substring(cbc:CompanyID, 1, 2) != 'DK')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB190] schemeID = DK:CVR, CompanyID must be a valid CVR number (like 'DK12345678', value found: '<xsl:text />
          <xsl:value-of select="cbc:CompanyID" />
          <xsl:text />')</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:CompanyID/@schemeID = 'DK:CPR') and not(string-length(cbc:CompanyID) = 10)">
      <svrl:successful-report test="(cbc:CompanyID/@schemeID = 'DK:CPR') and not(string-length(cbc:CompanyID) = 10)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB191] schemeID = DK:CPR, CompanyID must be a valid CPR number (like '1234560000', value found: '<xsl:text />
          <xsl:value-of select="cbc:CompanyID" />
          <xsl:text />')</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M21" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:PayeeParty/cac:Contact" mode="M21" priority="1001">
    <svrl:fired-rule context="doc:Reminder/cac:PayeeParty/cac:Contact" />

		<!--REPORT -->
<xsl:if test="(not(cbc:ID) or cbc:ID = '') and (not(cbc:Name) or cbc:Name = '') and (not(cbc:Telephone) or cbc:Telephone = '') and (not(cbc:Telefax) or cbc:Telefax = '') and (not(cbc:ElectronicMail) or cbc:ElectronicMail = '') and (not(cbc:Note) or cbc:Note = '') and not(cac:OtherCommunication)">
      <svrl:successful-report test="(not(cbc:ID) or cbc:ID = '') and (not(cbc:Name) or cbc:Name = '') and (not(cbc:Telephone) or cbc:Telephone = '') and (not(cbc:Telefax) or cbc:Telefax = '') and (not(cbc:ElectronicMail) or cbc:ElectronicMail = '') and (not(cbc:Note) or cbc:Note = '') and not(cac:OtherCommunication)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB235] At least one field in the Contact class should be specified</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:OtherCommunication/cbc:ChannelCode and cac:OtherCommunication/cbc:Channel">
      <svrl:successful-report test="cac:OtherCommunication/cbc:ChannelCode and cac:OtherCommunication/cbc:Channel">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB236] Use either ChannelCode or Channel</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:OtherCommunication and (normalize-space(cac:OtherCommunication/cbc:Value) = '')">
      <svrl:successful-report test="cac:OtherCommunication and (normalize-space(cac:OtherCommunication/cbc:Value) = '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB237] When Contact/OtherCommunication is used, the element Contact/OtherCommunication/Value must be filled out.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M21" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:PayeeParty/cac:Person" mode="M21" priority="1000">
    <svrl:fired-rule context="doc:Reminder/cac:PayeeParty/cac:Person" />

		<!--REPORT -->
<xsl:if test="(not(cbc:FamilyName) or cbc:FamilyName = '') and (not(cbc:FirstName) or cbc:FirstName = '')">
      <svrl:successful-report test="(not(cbc:FamilyName) or cbc:FamilyName = '') and (not(cbc:FirstName) or cbc:FirstName = '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB024] There must be a FirstName if the FamilyName is not present</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M21" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M21" priority="-1" />
  <xsl:template match="@*|node()" mode="M21" priority="-2">
    <xsl:apply-templates mode="M21" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN taxRepresentativeParty-->


	<!--RULE -->
<xsl:template match="doc:Reminder/cac:TaxRepresentativeParty" mode="M22" priority="1002">
    <svrl:fired-rule context="doc:Reminder/cac:TaxRepresentativeParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:WebsiteURI) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:WebsiteURI) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB355] WebsiteURI element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:LogoReferenceID) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:LogoReferenceID) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB356] LogoReferenceID element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:EndpointID) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:EndpointID) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB357] EndpointID element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:PartyIdentification) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:PartyIdentification) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB358] PartyIdentification element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:Language) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:Language) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB359] Language element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:PhysicalLocation) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:PhysicalLocation) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB360] PhysicalLocation element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:PartyLegalEntity) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:PartyLegalEntity) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB361] PartyLegalEntity element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:Contact) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:Contact) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB362] Contact element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:Person) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:Person) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB363] Person element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:PartyName and cac:PartyName/cbc:Name and (normalize-space(cac:PartyName/cbc:Name) != '')" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:PartyName and cac:PartyName/cbc:Name and (normalize-space(cac:PartyName/cbc:Name) != '')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB353] PartyName/Name is mandatory in TaxRepresentativeParty</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:PostalAddress and cac:PostalAddress/cbc:AddressFormatCode and (normalize-space(cac:PostalAddress/cbc:AddressFormatCode) != '')" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:PostalAddress and cac:PostalAddress/cbc:AddressFormatCode and (normalize-space(cac:PostalAddress/cbc:AddressFormatCode) != '')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB354] PostalAddress/AddressFormatCode is mandatory in TaxRepresentativeParty</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:PartyTaxScheme" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:PartyTaxScheme">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB371] PartyTaxScheme is mandatory in TaxRepresentativeParty</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(not(cac:PartyTaxScheme)) or cac:PartyTaxScheme/cac:TaxScheme" />
      <xsl:otherwise>
        <svrl:failed-assert test="(not(cac:PartyTaxScheme)) or cac:PartyTaxScheme/cac:TaxScheme">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB372] PartyTaxScheme/TaxScheme is mandatory in TaxRepresentativeParty</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M22" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:TaxRepresentativeParty/cac:PartyTaxScheme" mode="M22" priority="1001">
    <svrl:fired-rule context="doc:Reminder/cac:TaxRepresentativeParty/cac:PartyTaxScheme" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:TaxLevelCode) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:TaxLevelCode) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB192] TaxLevelCode element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:CompanyID) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:CompanyID) != ''">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB193] Invalid CompanyID. Must contain a value</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:CompanyID/@schemeID = 'DK:SE' or cbc:CompanyID/@schemeID = 'ZZZ' " />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:CompanyID/@schemeID = 'DK:SE' or cbc:CompanyID/@schemeID = 'ZZZ'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB195] Invalid schemeID. Must be a valid scheme for PartyTaxScheme/CompanyID</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:CompanyID/@schemeID = 'DK:SE') and (string-length(normalize-space(cbc:CompanyID)) != 10 or substring(cbc:CompanyID, 1, 2) != 'DK')">
      <svrl:successful-report test="(cbc:CompanyID/@schemeID = 'DK:SE') and (string-length(normalize-space(cbc:CompanyID)) != 10 or substring(cbc:CompanyID, 1, 2) != 'DK')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB196] schemeID = DK:SE, CompanyID must be a valid SE number (like 'DK12345678', value found: '<xsl:text />
          <xsl:value-of select="cbc:CompanyID" />
          <xsl:text />')</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M22" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:TaxRepresentativeParty/cac:PartyTaxScheme/cac:TaxScheme" mode="M22" priority="1000">
    <svrl:fired-rule context="doc:Reminder/cac:TaxRepresentativeParty/cac:PartyTaxScheme/cac:TaxScheme" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:ID) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:ID) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB041] ID element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:AddressTypeCode) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:AddressTypeCode) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB042] AddressTypeCode element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:Postbox) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:Postbox) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB043] Postbox element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:Floor) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:Floor) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB044] Floor element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:Room) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:Room) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB045] Room element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:StreetName) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:StreetName) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB046] StreetName element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:AdditionalStreetName) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:AdditionalStreetName) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB047] AdditionalStreetName element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:BlockName) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:BlockName) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB048] BlockName element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:BuildingName) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:BuildingName) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB049] BuildingName element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:BuildingNumber) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:BuildingNumber) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB050] BuildingNumber element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:InhouseMail) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:InhouseMail) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB051] InhouseMail element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:Department) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:Department) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB052] Department element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:MarkAttention) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:MarkAttention) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB053] MarkAttention element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:MarkCare) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:MarkCare) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB054] MarkCare element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:PlotIdentification) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:PlotIdentification) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB055] PlotIdentification element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:CitySubdivisionName) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:CitySubdivisionName) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB056] CitySubdivisionName element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:CityName) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:CityName) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB057] CityName element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:PostalZone) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:PostalZone) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB058] PostalZone element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:CountrySubentity) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:CountrySubentity) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB059] CountrySubentity element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:CountrySubentityCode) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:CountrySubentityCode) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB060] CountrySubentityCode element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:TimezoneOffset) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:TimezoneOffset) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB063] TimezoneOffset element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cac:AddressLine) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cac:AddressLine) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB234] AddressLine class must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cac:LocationCoordinate) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cac:LocationCoordinate) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB064] LocationCoordinate class must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:ID = '63') and cbc:TaxTypeCode">
      <svrl:successful-report test="(cbc:ID = '63') and cbc:TaxTypeCode">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB067] TaxTypeCode is not allowed when TaxScheme/ID equals '63' (Moms)</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:ID) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:ID) != ''">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB065] Invalid TaxScheme/ID. Must contain a value.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:Name) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:Name) != ''">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB066] Invalid Name. Must contain a value</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="not((cbc:ID = '63' or cbc:ID = 'VAT')) and not(contains($TaxType2, concat(',',cbc:TaxTypeCode,',')))">
      <svrl:successful-report test="not((cbc:ID = '63' or cbc:ID = 'VAT')) and not(contains($TaxType2, concat(',',cbc:TaxTypeCode,',')))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB197] TaxTypeCode must be a value from the '<xsl:text />
          <xsl:value-of select="$TaxType_listID2" />
          <xsl:text />' codelist when TaxScheme/ID is different from '63' or 'VAT' (Moms)</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID/@schemeID = $TaxScheme_schemeID or cbc:ID/@schemeID = $TaxScheme2_schemeID or cbc:ID/@schemeID = $TaxScheme4_schemeID or cbc:ID/@schemeID = $TaxScheme5_schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID/@schemeID = $TaxScheme_schemeID or cbc:ID/@schemeID = $TaxScheme2_schemeID or cbc:ID/@schemeID = $TaxScheme4_schemeID or cbc:ID/@schemeID = $TaxScheme5_schemeID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB070] Invalid schemeID. Must be either '<xsl:text />
            <xsl:value-of select="$TaxScheme_schemeID" />
            <xsl:text />', '<xsl:text />
            <xsl:value-of select="$TaxScheme2_schemeID" />
            <xsl:text />', '<xsl:text />
            <xsl:value-of select="$TaxScheme4_schemeID" />
            <xsl:text />' or '<xsl:text />
            <xsl:value-of select="$TaxScheme5_schemeID" />
            <xsl:text />'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:TaxTypeCode) and not((cbc:TaxTypeCode/@listID = $TaxType_listID) or (cbc:TaxTypeCode/@listID = $TaxType_listID2))">
      <svrl:successful-report test="(cbc:TaxTypeCode) and not((cbc:TaxTypeCode/@listID = $TaxType_listID) or (cbc:TaxTypeCode/@listID = $TaxType_listID2))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB071] Invalid listID. Must be either '<xsl:text />
          <xsl:value-of select="$TaxType_listID" />
          <xsl:text />' or '<xsl:text />
          <xsl:value-of select="$TaxType_listID2" />
          <xsl:text />'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID = '63') and cbc:Name != 'Moms'">
      <svrl:successful-report test="(cbc:ID = '63') and cbc:Name != 'Moms'">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB198] Name must equal 'Moms' when TaxScheme/ID equals '63' (Moms)</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID != '63') and cbc:Name = 'Moms'">
      <svrl:successful-report test="(cbc:ID != '63') and cbc:Name = 'Moms'">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB199] Name must correspond to the value of TaxScheme/ID</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cac:JurisdictionRegionAddress/cac:Country/cbc:IdentificationCode) and not(contains($CountryCode, concat(',',cac:JurisdictionRegionAddress/cac:Country/cbc:IdentificationCode,',')))">
      <svrl:successful-report test="(cac:JurisdictionRegionAddress/cac:Country/cbc:IdentificationCode) and not(contains($CountryCode, concat(',',cac:JurisdictionRegionAddress/cac:Country/cbc:IdentificationCode,',')))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB337] Invalid Country/IdentificationCode: '<xsl:text />
          <xsl:value-of select="cac:JurisdictionRegionAddress/cac:Country/cbc:IdentificationCode" />
          <xsl:text />'. Must be a value from the country codelist</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cac:JurisdictionRegionAddress) and cac:JurisdictionRegionAddress/cbc:AddressFormatCode != 'StructuredRegion'">
      <svrl:successful-report test="(cac:JurisdictionRegionAddress) and cac:JurisdictionRegionAddress/cbc:AddressFormatCode != 'StructuredRegion'">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB233] The AddressFormatCode under JurisdictionRegionAddress must always equal 'StructuredRegion'</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M22" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M22" priority="-1" />
  <xsl:template match="@*|node()" mode="M22" priority="-2">
    <xsl:apply-templates mode="M22" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN paymentmeans-->


	<!--RULE -->
<xsl:template match="doc:Reminder/cac:PaymentMeans" mode="M23" priority="1000">
    <svrl:fired-rule context="doc:Reminder/cac:PaymentMeans" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:PayerFinancialAccount/cac:FinancialInstitutionBranch/cac:Address) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:PayerFinancialAccount/cac:FinancialInstitutionBranch/cac:Address) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB151] Address class must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:PayerFinancialAccount/cac:Country) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:PayerFinancialAccount/cac:Country) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB162] Country class must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cac:Address) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cac:Address) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB243] Address class must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:PayeeFinancialAccount/cac:Country) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:PayeeFinancialAccount/cac:Country) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB244] Country class must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:PaymentMeansCode = '1' or cbc:PaymentMeansCode = '10' or cbc:PaymentMeansCode = '20' or cbc:PaymentMeansCode = '31' or cbc:PaymentMeansCode = '42' or cbc:PaymentMeansCode = '48' or cbc:PaymentMeansCode = '49' or cbc:PaymentMeansCode = '50' or cbc:PaymentMeansCode = '58' or cbc:PaymentMeansCode = '59' or cbc:PaymentMeansCode = '93' or cbc:PaymentMeansCode = '97'" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:PaymentMeansCode = '1' or cbc:PaymentMeansCode = '10' or cbc:PaymentMeansCode = '20' or cbc:PaymentMeansCode = '31' or cbc:PaymentMeansCode = '42' or cbc:PaymentMeansCode = '48' or cbc:PaymentMeansCode = '49' or cbc:PaymentMeansCode = '50' or cbc:PaymentMeansCode = '58' or cbc:PaymentMeansCode = '59' or cbc:PaymentMeansCode = '93' or cbc:PaymentMeansCode = '97'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB100] Invalid PaymentMeansCode. Must be a value from the codelist</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="count(../cac:PaymentMeans) > 1 and not(cbc:ID != '')">
      <svrl:successful-report test="count(../cac:PaymentMeans) > 1 and not(cbc:ID != '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[W-LIB241] PaymentMeans/ID should be used when more than one instance of the PaymentMeans class is present.</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:PayerFinancialAccount/cbc:AccountTypeCode and not(cac:PayerFinancialAccount/cbc:AccountTypeCode/@listID = 'urn:oioubl:codelist:accounttypecode-1.1')">
      <svrl:successful-report test="cac:PayerFinancialAccount/cbc:AccountTypeCode and not(cac:PayerFinancialAccount/cbc:AccountTypeCode/@listID = 'urn:oioubl:codelist:accounttypecode-1.1')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB105] Invalid listID. Must be 'urn:oioubl:codelist:accounttypecode-1.1'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:PayerFinancialAccount/cbc:AccountTypeCode and not(cac:PayerFinancialAccount/cbc:AccountTypeCode/@listAgencyID = '320')">
      <svrl:successful-report test="cac:PayerFinancialAccount/cbc:AccountTypeCode and not(cac:PayerFinancialAccount/cbc:AccountTypeCode/@listAgencyID = '320')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[W-LIB121] Invalid listAgencyID. Must be '320'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:PayeeFinancialAccount/cbc:AccountTypeCode and not(cac:PayeeFinancialAccount/cbc:AccountTypeCode/@listID = 'urn:oioubl:codelist:accounttypecode-1.1')">
      <svrl:successful-report test="cac:PayeeFinancialAccount/cbc:AccountTypeCode and not(cac:PayeeFinancialAccount/cbc:AccountTypeCode/@listID = 'urn:oioubl:codelist:accounttypecode-1.1')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB136] Invalid listID. Must be 'urn:oioubl:codelist:accounttypecode-1.1'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:PayeeFinancialAccount/cbc:AccountTypeCode and not(cac:PayeeFinancialAccount/cbc:AccountTypeCode/@listAgencyID = '320')">
      <svrl:successful-report test="cac:PayeeFinancialAccount/cbc:AccountTypeCode and not(cac:PayeeFinancialAccount/cbc:AccountTypeCode/@listAgencyID = '320')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[W-LIB141] Invalid listAgencyID. Must be '320'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:PaymentMeansCode = '31') and cbc:InstructionNote">
      <svrl:successful-report test="(cbc:PaymentMeansCode = '31') and cbc:InstructionNote">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB103] PaymentMeansCode = 31, InstructionNote element not allowed</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:PaymentMeansCode = '31') and not(cbc:PaymentChannelCode/@listID = 'urn:oioubl:codelist:paymentchannelcode-1.1')">
      <svrl:successful-report test="(cbc:PaymentMeansCode = '31') and not(cbc:PaymentChannelCode/@listID = 'urn:oioubl:codelist:paymentchannelcode-1.1')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB106] PaymentMeansCode = 31, Invalid listID. Must be 'urn:oioubl:codelist:paymentchannelcode-1.1'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:PaymentMeansCode = '31') and not(cac:PayeeFinancialAccount/cbc:ID)">
      <svrl:successful-report test="(cbc:PaymentMeansCode = '31') and not(cac:PayeeFinancialAccount/cbc:ID)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB107] PaymentMeansCode = 31, ID element is mandatory</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:PaymentMeansCode = '31') and not(cbc:PaymentChannelCode = 'IBAN' or cbc:PaymentChannelCode = 'ZZZ')">
      <svrl:successful-report test="(cbc:PaymentMeansCode = '31') and not(cbc:PaymentChannelCode = 'IBAN' or cbc:PaymentChannelCode = 'ZZZ')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB109] PaymentMeansCode = 31, PaymentChannelCode must equal IBAN or ZZZ</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:PaymentMeansCode = '31') and string-length(cac:PayerFinancialAccount/cbc:PaymentNote)> 20">
      <svrl:successful-report test="(cbc:PaymentMeansCode = '31') and string-length(cac:PayerFinancialAccount/cbc:PaymentNote)> 20">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB110] PaymentMeansCode = 31, PaymentNote must be no more than 20 characters</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:PaymentMeansCode = '31') and string-length(cac:PayeeFinancialAccount/cbc:PaymentNote)> 20">
      <svrl:successful-report test="(cbc:PaymentMeansCode = '31') and string-length(cac:PayeeFinancialAccount/cbc:PaymentNote)> 20">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB111] PaymentMeansCode = 31, PaymentNote must be no more than 20 characters</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:PaymentMeansCode = '31') and string-length(cac:CreditAccount/cbc:AccountID) > 8">
      <svrl:successful-report test="(cbc:PaymentMeansCode = '31') and string-length(cac:CreditAccount/cbc:AccountID) > 8">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB112] PaymentMeansCode = 31, AccountID must be no more than 8 characters</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:PaymentMeansCode = '31' and cbc:PaymentChannelCode = 'IBAN') and (cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID)">
      <svrl:successful-report test="(cbc:PaymentMeansCode = '31' and cbc:PaymentChannelCode = 'IBAN') and (cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB108] PaymentMeansCode = 31, FinancialInstitutionBranch/ID (Registreringsnummer) element is not used, when PaymentChannelCode equals IBAN</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:PaymentMeansCode = '31' and cbc:PaymentChannelCode = 'IBAN') and not(cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:ID)">
      <svrl:successful-report test="(cbc:PaymentMeansCode = '31' and cbc:PaymentChannelCode = 'IBAN') and not(cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:ID)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB113] PaymentMeansCode = 31, ID element is mandatory</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:PaymentMeansCode = '31' and cbc:PaymentChannelCode = 'IBAN') and string-length(cac:PayeeFinancialAccount/cbc:ID) > 34">
      <svrl:successful-report test="(cbc:PaymentMeansCode = '31' and cbc:PaymentChannelCode = 'IBAN') and string-length(cac:PayeeFinancialAccount/cbc:ID) > 34">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB114] PaymentMeansCode = 31, Account ID must be no more than 34 characters</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:PaymentMeansCode = '31' and cbc:PaymentChannelCode = 'IBAN') and string-length(cac:PayeeFinancialAccount/cbc:ID) &lt; 1">
      <svrl:successful-report test="(cbc:PaymentMeansCode = '31' and cbc:PaymentChannelCode = 'IBAN') and string-length(cac:PayeeFinancialAccount/cbc:ID) &lt; 1">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB115] PaymentMeansCode = 31, Account ID must must not be empty.</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:PaymentMeansCode = '31' and cbc:PaymentChannelCode = 'ZZZ') and not(cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID)">
      <svrl:successful-report test="(cbc:PaymentMeansCode = '31' and cbc:PaymentChannelCode = 'ZZZ') and not(cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB276] PaymentMeansCode = 31, FinancialInstitutionBranch/ID (Registreringsnummer) element is mandatory, when PaymentChannelCode equals ZZZ</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:PaymentMeansCode = '31' and cbc:PaymentChannelCode = 'ZZZ') and not(cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:Name)">
      <svrl:successful-report test="(cbc:PaymentMeansCode = '31' and cbc:PaymentChannelCode = 'ZZZ') and not(cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:Name)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB116] PaymentMeansCode = 31, FinancialInstitutionBranch/Name element is mandatory</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:PaymentMeansCode = '31' and cbc:PaymentChannelCode = 'ZZZ') and not(cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:Address)">
      <svrl:successful-report test="(cbc:PaymentMeansCode = '31' and cbc:PaymentChannelCode = 'ZZZ') and not(cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:Address)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB117] PaymentMeansCode = 31, FinancialInstitutionBranch/Address class is mandatory</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:PaymentMeansCode = '42') and cac:CreditAccount">
      <svrl:successful-report test="(cbc:PaymentMeansCode = '42') and cac:CreditAccount">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB122] PaymentMeansCode = 42, CreditAccount class not allowed</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:PaymentMeansCode = '42') and cbc:InstructionNote">
      <svrl:successful-report test="(cbc:PaymentMeansCode = '42') and cbc:InstructionNote">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB119] PaymentMeansCode = 42, InstructionNote element not allowed</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:PaymentMeansCode = '42') and not (cbc:PaymentChannelCode/@listID = 'urn:oioubl:codelist:paymentchannelcode-1.1')">
      <svrl:successful-report test="(cbc:PaymentMeansCode = '42') and not (cbc:PaymentChannelCode/@listID = 'urn:oioubl:codelist:paymentchannelcode-1.1')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB123] PaymentMeansCode = 42, Invalid listID. Must be 'urn:oioubl:codelist:paymentchannelcode-1.1'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:PaymentMeansCode = '42') and cbc:PaymentChannelCode != 'DK:BANK'">
      <svrl:successful-report test="(cbc:PaymentMeansCode = '42') and cbc:PaymentChannelCode != 'DK:BANK'">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB128] PaymentMeansCode = 42, PaymentChannelCode must equal DK:BANK</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:PaymentMeansCode = '42') and string-length(cac:PayerFinancialAccount/cbc:PaymentNote)> 20">
      <svrl:successful-report test="(cbc:PaymentMeansCode = '42') and string-length(cac:PayerFinancialAccount/cbc:PaymentNote)> 20">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB129] PaymentMeansCode = 42, PaymentNote must be no more than 20 characters</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:PaymentMeansCode = '42') and string-length(cac:PayeeFinancialAccount/cbc:PaymentNote)> 20">
      <svrl:successful-report test="(cbc:PaymentMeansCode = '42') and string-length(cac:PayeeFinancialAccount/cbc:PaymentNote)> 20">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB133] PaymentMeansCode = 42, PaymentNote must be no more than 20 characters</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:PaymentMeansCode = '42') and (cac:PayerFinancialAccount/cac:FinancialInstitutionBranch) and not(cac:PayerFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID)">
      <svrl:successful-report test="(cbc:PaymentMeansCode = '42') and (cac:PayerFinancialAccount/cac:FinancialInstitutionBranch) and not(cac:PayerFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB124] PaymentMeansCode = 42, FinancialInstitutionBranch/ID (Registreringsnummer) element is mandatory</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:PaymentMeansCode = '42') and not(cac:PayeeFinancialAccount)">
      <svrl:successful-report test="(cbc:PaymentMeansCode = '42') and not(cac:PayeeFinancialAccount)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB125] PaymentMeansCode = 42, PayeeFinancialAccount class is mandatory</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:PaymentMeansCode = '42') and not(cac:PayeeFinancialAccount/cbc:ID)">
      <svrl:successful-report test="(cbc:PaymentMeansCode = '42') and not(cac:PayeeFinancialAccount/cbc:ID)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB126] PaymentMeansCode = 42, Account ID element is mandatory</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:PaymentMeansCode = '42') and not(cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID)">
      <svrl:successful-report test="(cbc:PaymentMeansCode = '42') and not(cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB127] PaymentMeansCode = 42, FinancialInstitutionBranch/ID (Registreringsnummer)  element is mandatory</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:PaymentMeansCode = '42') and string-length(cac:PayerFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID) > 4">
      <svrl:successful-report test="(cbc:PaymentMeansCode = '42') and string-length(cac:PayerFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID) > 4">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB130] PaymentMeansCode = 42, FinancialInstitutionBranch/ID (Registreringsnummer) must be no more than 4 numerical characters</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:PaymentMeansCode = '42') and string-length(cac:PayeeFinancialAccount/cbc:ID)> 10">
      <svrl:successful-report test="(cbc:PaymentMeansCode = '42') and string-length(cac:PayeeFinancialAccount/cbc:ID)> 10">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB131] PaymentMeansCode = 42,  Account ID must be no more than 10 characters</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:PaymentMeansCode = '42') and string-length(cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID)> 4">
      <svrl:successful-report test="(cbc:PaymentMeansCode = '42') and string-length(cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID)> 4">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB132] PaymentMeansCode = 42, FinancialInstitutionBranch/ID (Registreringsnummer) must be no more than 4 numerical characters</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:PaymentMeansCode = '42') and not(number(cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID))">
      <svrl:successful-report test="(cbc:PaymentMeansCode = '42') and not(number(cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB311] FinancialInstitutionBranch/ID (Registreringsnummer) must contain a numerical value</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:PaymentMeansCode = '48' and cbc:PaymentChannelCode">
      <svrl:successful-report test="cbc:PaymentMeansCode = '48' and cbc:PaymentChannelCode">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB365] When PaymentMeansCode is '48', PaymentChannelCode class must be excluded</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:PaymentMeansCode = '48' and cbc:InstructionID">
      <svrl:successful-report test="cbc:PaymentMeansCode = '48' and cbc:InstructionID">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB366] When PaymentMeansCode is '48', InstructionID class must be excluded</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:PaymentMeansCode = '48' and cbc:InstructionNote">
      <svrl:successful-report test="cbc:PaymentMeansCode = '48' and cbc:InstructionNote">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB367] When PaymentMeansCode is '48', InstructionNote class must be excluded</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:PaymentMeansCode = '48' and cac:PayerFinancialAccount">
      <svrl:successful-report test="cbc:PaymentMeansCode = '48' and cac:PayerFinancialAccount">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB368] When PaymentMeansCode is '48', PayerFinancialAccount class must be excluded</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:PaymentMeansCode = '48' and cac:PayeeFinancialAccount">
      <svrl:successful-report test="cbc:PaymentMeansCode = '48' and cac:PayeeFinancialAccount">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB369] When PaymentMeansCode is '48', PayeeFinancialAccount class must be excluded</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:PaymentMeansCode = '48' and cac:CreditAccount">
      <svrl:successful-report test="cbc:PaymentMeansCode = '48' and cac:CreditAccount">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB370] When PaymentMeansCode is '48', CreditAccount class must be excluded</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:PaymentMeansCode = '48' and not (cac:CardAccount)">
      <svrl:successful-report test="cbc:PaymentMeansCode = '48' and not (cac:CardAccount)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB342] When PaymentMeansCode is '48', the CardAccount class must be used</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:PaymentMeansCode = '48' and cac:CardAccount/cbc:CardTypeCode">
      <svrl:successful-report test="cbc:PaymentMeansCode = '48' and cac:CardAccount/cbc:CardTypeCode">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB343] When PaymentMeansCode is '48', CardAccount/CardTypeCode class must be excluded</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:PaymentMeansCode = '48' and cac:CardAccount/cbc:ValidityStartDate">
      <svrl:successful-report test="cbc:PaymentMeansCode = '48' and cac:CardAccount/cbc:ValidityStartDate">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB344] When PaymentMeansCode is '48', CardAccount/ValidityStartDate class must be excluded</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:PaymentMeansCode = '48' and cac:CardAccount/cbc:ExpiryDate">
      <svrl:successful-report test="cbc:PaymentMeansCode = '48' and cac:CardAccount/cbc:ExpiryDate">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB345] When PaymentMeansCode is '48', CardAccount/ExpiryDate class must be excluded</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:PaymentMeansCode = '48' and cac:CardAccount/cbc:IssuerID">
      <svrl:successful-report test="cbc:PaymentMeansCode = '48' and cac:CardAccount/cbc:IssuerID">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB346] When PaymentMeansCode is '48', CardAccount/IssuerID class must be excluded</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:PaymentMeansCode = '48' and cac:CardAccount/cbc:IssueNumberID">
      <svrl:successful-report test="cbc:PaymentMeansCode = '48' and cac:CardAccount/cbc:IssueNumberID">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB347] When PaymentMeansCode is '48', CardAccount/IssueNumberID class must be excluded</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:PaymentMeansCode = '48' and cac:CardAccount/cbc:CV2ID">
      <svrl:successful-report test="cbc:PaymentMeansCode = '48' and cac:CardAccount/cbc:CV2ID">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB348] When PaymentMeansCode is '48', CardAccount/CV2ID class must be excluded</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:PaymentMeansCode = '48' and cac:CardAccount/cbc:CardChipCode">
      <svrl:successful-report test="cbc:PaymentMeansCode = '48' and cac:CardAccount/cbc:CardChipCode">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB349] When PaymentMeansCode is '48', CardAccount/CardChipCode class must be excluded</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:PaymentMeansCode = '48' and cac:CardAccount/cbc:ChipApplicationID">
      <svrl:successful-report test="cbc:PaymentMeansCode = '48' and cac:CardAccount/cbc:ChipApplicationID">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB350] When PaymentMeansCode is '48', CardAccount/ChipApplicationID class must be excluded</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:PaymentMeansCode = '49') and cbc:InstructionNote">
      <svrl:successful-report test="(cbc:PaymentMeansCode = '49') and cbc:InstructionNote">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB135] PaymentMeansCode = 49, InstructionNote element not allowed</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:PaymentMeansCode = '49') and cac:CreditAccount">
      <svrl:successful-report test="(cbc:PaymentMeansCode = '49') and cac:CreditAccount">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB137] PaymentMeansCode = 49, CreditAccount class not allowed</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:PaymentMeansCode = '49') and cbc:PaymentChannelCode and cbc:InstructionID">
      <svrl:successful-report test="(cbc:PaymentMeansCode = '49') and cbc:PaymentChannelCode and cbc:InstructionID">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB134] PaymentMeansCode = 49, Use either PaymentChannelCode or InstructionID element</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:PaymentMeansCode = '49') and string-length(cac:PayerFinancialAccount/cbc:PaymentNote)> 20">
      <svrl:successful-report test="(cbc:PaymentMeansCode = '49') and string-length(cac:PayerFinancialAccount/cbc:PaymentNote)> 20">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB288] PaymentMeansCode = 49, PaymentNote must be no more than 20 characters</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:PaymentMeansCode = '49' and cbc:PaymentChannelCode) and not(cbc:PaymentChannelCode = 'IBAN' or cbc:PaymentChannelCode = 'DK:BANK')">
      <svrl:successful-report test="(cbc:PaymentMeansCode = '49' and cbc:PaymentChannelCode) and not(cbc:PaymentChannelCode = 'IBAN' or cbc:PaymentChannelCode = 'DK:BANK')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB289] PaymentMeansCode = 49, If present, PaymentChannelCode must equal IBAN or DK:BANK</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:PaymentMeansCode = '49') and string-length(cbc:InstructionID) > 60">
      <svrl:successful-report test="(cbc:PaymentMeansCode = '49') and string-length(cbc:InstructionID) > 60">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB140] PaymentMeansCode = 49, InstructionID must be no more than 60 characters</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:PaymentMeansCode = '49' and cbc:PaymentChannelCode = 'DK:BANK') and (string-length(cac:PayerFinancialAccount/cbc:ID) != 10)">
      <svrl:successful-report test="(cbc:PaymentMeansCode = '49' and cbc:PaymentChannelCode = 'DK:BANK') and (string-length(cac:PayerFinancialAccount/cbc:ID) != 10)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB290] PaymentMeansCode = 49, For DK:BANK, Account ID must be 10 characters</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:PaymentMeansCode = '49' and cbc:PaymentChannelCode = 'DK:BANK') and (string-length(cac:PayerFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID) != 4)">
      <svrl:successful-report test="(cbc:PaymentMeansCode = '49' and cbc:PaymentChannelCode = 'DK:BANK') and (string-length(cac:PayerFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID) != 4)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB291] PaymentMeansCode = 49, For DK:BANK, FinancialInstitutionBranch/ID (Registreringsnummer) must be 4 numerical characters</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:PaymentMeansCode = '49' and cbc:PaymentChannelCode = 'IBAN') and string-length(cac:PayerFinancialAccount/cbc:ID) > 34">
      <svrl:successful-report test="(cbc:PaymentMeansCode = '49' and cbc:PaymentChannelCode = 'IBAN') and string-length(cac:PayerFinancialAccount/cbc:ID) > 34">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB292] PaymentMeansCode = 49, For IBAN, Account ID must be no more than 34 characters</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:PaymentMeansCode = '49' and cbc:PaymentChannelCode = 'IBAN') and string-length(cac:PayerFinancialAccount/cbc:ID) &lt; 18">
      <svrl:successful-report test="(cbc:PaymentMeansCode = '49' and cbc:PaymentChannelCode = 'IBAN') and string-length(cac:PayerFinancialAccount/cbc:ID) &lt; 18">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB293] PaymentMeansCode = 49, For IBAN, Account ID must be at least 18 characters</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:PaymentMeansCode = '49' and cbc:PaymentChannelCode = 'IBAN') and (cac:PayerFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID)">
      <svrl:successful-report test="(cbc:PaymentMeansCode = '49' and cbc:PaymentChannelCode = 'IBAN') and (cac:PayerFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB294] PaymentMeansCode = 49, FinancialInstitutionBranch/ID (Registreringsnummer) element is not used, when PaymentChannelCode equals IBAN</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:PaymentMeansCode = '49' and cbc:PaymentChannelCode = 'IBAN') and not(cac:PayerFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:ID)">
      <svrl:successful-report test="(cbc:PaymentMeansCode = '49' and cbc:PaymentChannelCode = 'IBAN') and not(cac:PayerFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:ID)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB295] PaymentMeansCode = 49, For IBAN, ID element is mandatory</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:PaymentMeansCode = '50') and cac:CreditAccount">
      <svrl:successful-report test="(cbc:PaymentMeansCode = '50') and cac:CreditAccount">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB142] PaymentMeansCode = 50, CreditAccount class not allowed</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:PaymentMeansCode = '50') and not(cbc:PaymentID)">
      <svrl:successful-report test="(cbc:PaymentMeansCode = '50') and not(cbc:PaymentID)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB144] PaymentMeansCode = 50, PaymentID element is mandatory</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:PaymentMeansCode = '50') and not(cac:PayeeFinancialAccount)">
      <svrl:successful-report test="(cbc:PaymentMeansCode = '50') and not(cac:PayeeFinancialAccount)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB319] PaymentMeansCode = 50, PayeeFinancialAccount class is mandatory.</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:PaymentMeansCode = '50') and not(cac:PayeeFinancialAccount/cbc:ID)">
      <svrl:successful-report test="(cbc:PaymentMeansCode = '50') and not(cac:PayeeFinancialAccount/cbc:ID)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB320] PaymentMeansCode = 50, PayeeFinancialAccount.ID element is mandatory.</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:PaymentMeansCode = '50') and (cbc:PaymentID = '04' or cbc:PaymentID = '15') and not(cbc:InstructionID)">
      <svrl:successful-report test="(cbc:PaymentMeansCode = '50') and (cbc:PaymentID = '04' or cbc:PaymentID = '15') and not(cbc:InstructionID)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB145] PaymentMeansCode = 50, InstructionID is mandatory when PaymentID equals 04 or 15</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:PaymentMeansCode = '50' and cbc:PaymentChannelCode) and cbc:PaymentChannelCode != 'DK:GIRO'">
      <svrl:successful-report test="(cbc:PaymentMeansCode = '50' and cbc:PaymentChannelCode) and cbc:PaymentChannelCode != 'DK:GIRO'">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB146] PaymentMeansCode = 50, PaymentChannelCode must equal DK:GIRO</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:PaymentMeansCode = '50' and cbc:PaymentChannelCode) and not(cbc:PaymentChannelCode/@listID = 'urn:oioubl:codelist:paymentchannelcode-1.1')">
      <svrl:successful-report test="(cbc:PaymentMeansCode = '50' and cbc:PaymentChannelCode) and not(cbc:PaymentChannelCode/@listID = 'urn:oioubl:codelist:paymentchannelcode-1.1')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB143] PaymentMeansCode = 50, Invalid listID. Must be 'urn:oioubl:codelist:paymentchannelcode-1.1'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:PaymentMeansCode = '50') and not(cbc:PaymentID = '01' or cbc:PaymentID = '04' or cbc:PaymentID = '15')">
      <svrl:successful-report test="(cbc:PaymentMeansCode = '50') and not(cbc:PaymentID = '01' or cbc:PaymentID = '04' or cbc:PaymentID = '15')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB147] PaymentMeansCode = 50, PaymentID must equal 01, 04 or 15</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:PaymentMeansCode = '50') and cbc:InstructionNote and not(cbc:PaymentID = '01')">
      <svrl:successful-report test="(cbc:PaymentMeansCode = '50') and cbc:InstructionNote and not(cbc:PaymentID = '01')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB148] PaymentMeansCode = 50, InstructionNote only allowed if PaymentID equals 01</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:PaymentMeansCode = '50') and string-length(cbc:InstructionID) > 16">
      <svrl:successful-report test="(cbc:PaymentMeansCode = '50') and string-length(cbc:InstructionID) > 16">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB149] PaymentMeansCode = 50, InstructionID must be no more than 16 characters</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:PaymentMeansCode = '50') and (cbc:PaymentID = '04' or cbc:PaymentID = '15') and string(number(cbc:InstructionID)) = 'NaN'">
      <svrl:successful-report test="(cbc:PaymentMeansCode = '50') and (cbc:PaymentID = '04' or cbc:PaymentID = '15') and string(number(cbc:InstructionID)) = 'NaN'">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB312] PaymentMeansCode = 50, InstructionID must be a numeric value when PaymentID equals 04 or 15.</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:PaymentMeansCode = '50' or cbc:PaymentChannelCode ='DK:GIRO') and (string-length(cac:PayeeFinancialAccount/cbc:ID) &lt; 7 or string-length(cac:PayeeFinancialAccount/cbc:ID) > 8 or string(number(cac:PayeeFinancialAccount/cbc:ID)) = 'NaN')">
      <svrl:successful-report test="(cbc:PaymentMeansCode = '50' or cbc:PaymentChannelCode ='DK:GIRO') and (string-length(cac:PayeeFinancialAccount/cbc:ID) &lt; 7 or string-length(cac:PayeeFinancialAccount/cbc:ID) > 8 or string(number(cac:PayeeFinancialAccount/cbc:ID)) = 'NaN')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB321] PaymentMeansCode = 50 or PaymentChannelCode = DK:GIRO, PayeeFinancialAccount.ID must consist of 7 or 8 numerical characters.</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:PaymentMeansCode = '58') and (not(cac:PayeeFinancialAccount/cbc:ID) or normalize-space(cac:PayeeFinancialAccount/cbc:ID) = '')">
      <svrl:successful-report test="(cbc:PaymentMeansCode = '58') and (not(cac:PayeeFinancialAccount/cbc:ID) or normalize-space(cac:PayeeFinancialAccount/cbc:ID) = '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB377] PaymentMeansCode = 58, PayeeFinancialAccount.ID must be used</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:PaymentMeansCode = '58') and (cbc:PaymentChannelCode) and not(cbc:PaymentChannelCode = 'IBAN')">
      <svrl:successful-report test="(cbc:PaymentMeansCode = '58') and (cbc:PaymentChannelCode) and not(cbc:PaymentChannelCode = 'IBAN')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB379] PaymentMeansCode = 58, when PaymentChannelCode is used it must be 'IBAN'.</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:PaymentMeansCode = '59') and (cbc:PaymentChannelCode) and not(cbc:PaymentChannelCode = 'IBAN')">
      <svrl:successful-report test="(cbc:PaymentMeansCode = '59') and (cbc:PaymentChannelCode) and not(cbc:PaymentChannelCode = 'IBAN')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB380] PaymentMeansCode = 59, when PaymentChannelCode is used it must be 'IBAN'.</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:PaymentMeansCode = '93') and not(cbc:PaymentID)">
      <svrl:successful-report test="(cbc:PaymentMeansCode = '93') and not(cbc:PaymentID)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB152] PaymentMeansCode = 93, PaymentID element is mandatory</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:PaymentMeansCode = '93') and (cbc:PaymentID = '71' or cbc:PaymentID = '75') and not(cbc:InstructionID)">
      <svrl:successful-report test="(cbc:PaymentMeansCode = '93') and (cbc:PaymentID = '71' or cbc:PaymentID = '75') and not(cbc:InstructionID)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB153] PaymentMeansCode = 93, InstructionID is mandatory when PaymentID equals 71 or 75</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:PaymentMeansCode = '93' and cbc:PaymentChannelCode) and cbc:PaymentChannelCode != 'DK:FIK'">
      <svrl:successful-report test="(cbc:PaymentMeansCode = '93' and cbc:PaymentChannelCode) and cbc:PaymentChannelCode != 'DK:FIK'">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB277] PaymentMeansCode = 93, PaymentChannelCode must equal DK:FIK</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:PaymentMeansCode = '93' and cbc:PaymentChannelCode) and not(cbc:PaymentChannelCode/@listID = 'urn:oioubl:codelist:paymentchannelcode-1.1')">
      <svrl:successful-report test="(cbc:PaymentMeansCode = '93' and cbc:PaymentChannelCode) and not(cbc:PaymentChannelCode/@listID = 'urn:oioubl:codelist:paymentchannelcode-1.1')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB278] PaymentMeansCode = 93, Invalid listID. Must be 'urn:oioubl:codelist:paymentchannelcode-1.1'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:PaymentMeansCode = '93') and cbc:InstructionNote and not(cbc:PaymentID = '73' or cbc:PaymentID = '75')">
      <svrl:successful-report test="(cbc:PaymentMeansCode = '93') and cbc:InstructionNote and not(cbc:PaymentID = '73' or cbc:PaymentID = '75')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB154] PaymentMeansCode = 93, InstructionNote only allowed if PaymentID equals 73 or 75</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:PaymentMeansCode = '93') and not(cbc:PaymentID = '71' or cbc:PaymentID = '73' or cbc:PaymentID = '75')">
      <svrl:successful-report test="(cbc:PaymentMeansCode = '93') and not(cbc:PaymentID = '71' or cbc:PaymentID = '73' or cbc:PaymentID = '75')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB155] PaymentMeansCode = 93, PaymentID must equal 71, 73 or 75</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:PaymentMeansCode = '93') and cbc:PaymentID = '71' and string-length(cbc:InstructionID) != 15">
      <svrl:successful-report test="(cbc:PaymentMeansCode = '93') and cbc:PaymentID = '71' and string-length(cbc:InstructionID) != 15">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB156] PaymentMeansCode = 93, InstructionID must be equal to 15 characters (when PaymentID equals 71)</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:PaymentMeansCode = '93') and cbc:PaymentID = '75' and string-length(cbc:InstructionID) != 16">
      <svrl:successful-report test="(cbc:PaymentMeansCode = '93') and cbc:PaymentID = '75' and string-length(cbc:InstructionID) != 16">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB157] PaymentMeansCode = 93, InstructionID must be equal to 16 characters (when PaymentID equals 75)</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:PaymentMeansCode = '93') and (cbc:PaymentID = '71' or cbc:PaymentID = '75') and string(number(cbc:InstructionID)) = 'NaN'">
      <svrl:successful-report test="(cbc:PaymentMeansCode = '93') and (cbc:PaymentID = '71' or cbc:PaymentID = '75') and string(number(cbc:InstructionID)) = 'NaN'">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB336] PaymentMeansCode = 93, InstructionID must be a numeric value when PaymentID equals 71 or 75.</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:PaymentMeansCode = '93') and cbc:PaymentID = '73' and cbc:InstructionID">
      <svrl:successful-report test="(cbc:PaymentMeansCode = '93') and cbc:PaymentID = '73' and cbc:InstructionID">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB275] PaymentMeansCode = 93, InstructionID only allowed if PaymentID equals 71 or 75</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:PaymentMeansCode = '93') and string-length(cac:CreditAccount/cbc:AccountID) != 8">
      <svrl:successful-report test="(cbc:PaymentMeansCode = '93') and string-length(cac:CreditAccount/cbc:AccountID) != 8">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB305] PaymentMeansCode = 93, AccountID must be 8 characters</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:PaymentMeansCode = '97') and cbc:PaymentChannelCode and not(cbc:PaymentChannelCode = 'DK:NEMKONTO')">
      <svrl:successful-report test="(cbc:PaymentMeansCode = '97') and cbc:PaymentChannelCode and not(cbc:PaymentChannelCode = 'DK:NEMKONTO')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB158] PaymentMeansCode = 97, PaymentChannelCode element only allowed with value = "DK:NEMKONTO"</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:PaymentMeansCode = '97') and cbc:InstructionID">
      <svrl:successful-report test="(cbc:PaymentMeansCode = '97') and cbc:InstructionID">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB159] PaymentMeansCode = 97, InstructionID element not allowed</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:PaymentMeansCode = '97') and cbc:InstructionNote">
      <svrl:successful-report test="(cbc:PaymentMeansCode = '97') and cbc:InstructionNote">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB160] PaymentMeansCode = 97, InstructionNote element not allowed</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:PaymentMeansCode = '97') and cbc:PaymentID">
      <svrl:successful-report test="(cbc:PaymentMeansCode = '97') and cbc:PaymentID">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB161] PaymentMeansCode = 97, PaymentID element not allowed</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:PaymentMeansCode = '97') and cac:PayerFinancialAccount">
      <svrl:successful-report test="(cbc:PaymentMeansCode = '97') and cac:PayerFinancialAccount">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB163] PaymentMeansCode = 97, PayerFinancialAccount class not allowed</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:PaymentMeansCode = '97') and cac:PayeeFinancialAccount">
      <svrl:successful-report test="(cbc:PaymentMeansCode = '97') and cac:PayeeFinancialAccount">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB164] PaymentMeansCode = 97, PayeeFinancialAccount class not allowed</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:PaymentMeansCode = '97') and cac:CreditAccount">
      <svrl:successful-report test="(cbc:PaymentMeansCode = '97') and cac:CreditAccount">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB165] PaymentMeansCode = 97, CreditAccount class not allowed</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M23" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M23" priority="-1" />
  <xsl:template match="@*|node()" mode="M23" priority="-2">
    <xsl:apply-templates mode="M23" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN paymentterms-->


	<!--RULE -->
<xsl:template match="doc:Reminder/cac:PaymentTerms" mode="M24" priority="1006">
    <svrl:fired-rule context="doc:Reminder/cac:PaymentTerms" />

		<!--REPORT -->
<xsl:if test="count(../cac:PaymentTerms) > 1 and not(cbc:ID != '')">
      <svrl:successful-report test="count(../cac:PaymentTerms) > 1 and not(cbc:ID != '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[W-LIB245]: ID should be used when more than one instance of the PaymentTerms class is present</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:ID = 'Factoring' and not(cbc:Note != '')">
      <svrl:successful-report test="cbc:ID = 'Factoring' and not(cbc:Note != '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB246] when ID equals 'Factoring', Note element is mandatory (factoring note)</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="count(cbc:Note) > 1">
      <svrl:successful-report test="count(cbc:Note) > 1">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB247] No more than one Note element may be present</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M24" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:PaymentTerms/cbc:PaymentMeansID" mode="M24" priority="1005">
    <svrl:fired-rule context="doc:Reminder/cac:PaymentTerms/cbc:PaymentMeansID" />
    <xsl:apply-templates mode="M24" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:PaymentTerms/cbc:Amount" mode="M24" priority="1004">
    <svrl:fired-rule context="doc:Reminder/cac:PaymentTerms/cbc:Amount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(starts-with(.,'-')) and . != 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(starts-with(.,'-')) and . != 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB019] Invalid <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />. Must not be negative or zero</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M24" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:PaymentTerms/cac:SettlementPeriod" mode="M24" priority="1003">
    <svrl:fired-rule context="doc:Reminder/cac:PaymentTerms/cac:SettlementPeriod" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:DurationMeasure) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:DurationMeasure) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB076] DurationMeasure element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:DescriptionCode) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:DescriptionCode) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB077] DescriptionCode element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:StartTime) and (not(cbc:StartDate) or cbc:StartDate = '')">
      <svrl:successful-report test="(cbc:StartTime) and (not(cbc:StartDate) or cbc:StartDate = '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB078] There must be a StartDate if you have a StartTime</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:EndTime) and (not(cbc:EndDate) or cbc:EndDate = '')">
      <svrl:successful-report test="(cbc:EndTime) and (not(cbc:EndDate) or cbc:EndDate = '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB079] There must be a EndDate if you have a EndTime</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:StartDate and cbc:EndDate) and not(number(translate(cbc:EndDate,'-','')) > number(translate(cbc:StartDate,'-','')) or number(translate(cbc:EndDate,'-','')) = number(translate(cbc:StartDate,'-','')))">
      <svrl:successful-report test="(cbc:StartDate and cbc:EndDate) and not(number(translate(cbc:EndDate,'-','')) > number(translate(cbc:StartDate,'-','')) or number(translate(cbc:EndDate,'-','')) = number(translate(cbc:StartDate,'-','')))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB080] The EndDate must be greater or equal to the startdate</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:StartTime and cbc:EndTime) and not(number(translate(cbc:EndTime,':','')) > number(translate(cbc:StartTime,':','')) or number(translate(cbc:EndTime,':','')) = number(translate(cbc:StartTime,':','')))">
      <svrl:successful-report test="(cbc:StartTime and cbc:EndTime) and not(number(translate(cbc:EndTime,':','')) > number(translate(cbc:StartTime,':','')) or number(translate(cbc:EndTime,':','')) = number(translate(cbc:StartTime,':','')))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB081] EndTime must be greater or equal to StartTime</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M24" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:PaymentTerms/cac:SettlementPeriod/cbc:Description" mode="M24" priority="1002">
    <svrl:fired-rule context="doc:Reminder/cac:PaymentTerms/cac:SettlementPeriod/cbc:Description" />

		<!--REPORT -->
<xsl:if test="count(../cbc:Description) > 1 and not(./@languageID)">
      <svrl:successful-report test="count(../cbc:Description) > 1 and not(./@languageID)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[W-LIB222] The attribute languageID should be used when more than one Description element is present</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID">
      <svrl:successful-report test="local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[W-LIB223] Multilanguage error. Replicated Description elements with same languageID attribute value</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M24" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:PaymentTerms/cac:PenaltyPeriod" mode="M24" priority="1001">
    <svrl:fired-rule context="doc:Reminder/cac:PaymentTerms/cac:PenaltyPeriod" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:DurationMeasure) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:DurationMeasure) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB076] DurationMeasure element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:DescriptionCode) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:DescriptionCode) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB077] DescriptionCode element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:StartTime) and (not(cbc:StartDate) or cbc:StartDate = '')">
      <svrl:successful-report test="(cbc:StartTime) and (not(cbc:StartDate) or cbc:StartDate = '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB078] There must be a StartDate if you have a StartTime</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:EndTime) and (not(cbc:EndDate) or cbc:EndDate = '')">
      <svrl:successful-report test="(cbc:EndTime) and (not(cbc:EndDate) or cbc:EndDate = '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB079] There must be a EndDate if you have a EndTime</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:StartDate and cbc:EndDate) and not(number(translate(cbc:EndDate,'-','')) > number(translate(cbc:StartDate,'-','')) or number(translate(cbc:EndDate,'-','')) = number(translate(cbc:StartDate,'-','')))">
      <svrl:successful-report test="(cbc:StartDate and cbc:EndDate) and not(number(translate(cbc:EndDate,'-','')) > number(translate(cbc:StartDate,'-','')) or number(translate(cbc:EndDate,'-','')) = number(translate(cbc:StartDate,'-','')))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB080] The EndDate must be greater or equal to the startdate</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:StartTime and cbc:EndTime) and not(number(translate(cbc:EndTime,':','')) > number(translate(cbc:StartTime,':','')) or number(translate(cbc:EndTime,':','')) = number(translate(cbc:StartTime,':','')))">
      <svrl:successful-report test="(cbc:StartTime and cbc:EndTime) and not(number(translate(cbc:EndTime,':','')) > number(translate(cbc:StartTime,':','')) or number(translate(cbc:EndTime,':','')) = number(translate(cbc:StartTime,':','')))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB081] EndTime must be greater or equal to StartTime</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M24" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:PaymentTerms/cac:PenaltyPeriod/cbc:Description" mode="M24" priority="1000">
    <svrl:fired-rule context="doc:Reminder/cac:PaymentTerms/cac:PenaltyPeriod/cbc:Description" />

		<!--REPORT -->
<xsl:if test="count(../cbc:Description) > 1 and not(./@languageID)">
      <svrl:successful-report test="count(../cbc:Description) > 1 and not(./@languageID)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[W-LIB222] The attribute languageID should be used when more than one Description element is present</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID">
      <svrl:successful-report test="local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[W-LIB223] Multilanguage error. Replicated Description elements with same languageID attribute value</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M24" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M24" priority="-1" />
  <xsl:template match="@*|node()" mode="M24" priority="-2">
    <xsl:apply-templates mode="M24" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN prepaidpayment-->


	<!--RULE -->
<xsl:template match="doc:Reminder/cac:PrepaidPayment" mode="M25" priority="1000">
    <svrl:fired-rule context="doc:Reminder/cac:PrepaidPayment" />
    <xsl:apply-templates mode="M25" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M25" priority="-1" />
  <xsl:template match="@*|node()" mode="M25" priority="-2">
    <xsl:apply-templates mode="M25" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:PrepaidPayment/cbc:PaidAmount" mode="M0" priority="1008">
    <svrl:fired-rule context="doc:Reminder/cac:PrepaidPayment/cbc:PaidAmount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(starts-with(.,'-')) and . != 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(starts-with(.,'-')) and . != 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB013] Invalid <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />. Must not be negative or zero</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="string-length(substring-after(., '.')) != 2">
      <svrl:successful-report test="string-length(substring-after(., '.')) != 2">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB014] Invalid <xsl:text />
          <xsl:value-of select="name(.)" />
          <xsl:text />. Must have 2 decimals</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M0" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN allowancecharge-->


	<!--RULE -->
<xsl:template match="doc:Reminder/cac:AllowanceCharge" mode="M27" priority="1006">
    <svrl:fired-rule context="doc:Reminder/cac:AllowanceCharge" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:TaxTotal) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:TaxTotal) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB224] TaxTotal class must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:PaymentMeans) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:PaymentMeans) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB225] PaymentMeans class must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:TaxCategory) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:TaxCategory) = 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB226] One TaxCategory class must be present</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="cbc:MultiplierFactorNumeric and not(cbc:BaseAmount != '')">
      <svrl:successful-report test="cbc:MultiplierFactorNumeric and not(cbc:BaseAmount != '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB248] When MultiplierFactorNumeric is used, BaseAmount is mandatory</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="starts-with(cbc:MultiplierFactorNumeric,'-')">
      <svrl:successful-report test="starts-with(cbc:MultiplierFactorNumeric,'-')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB227] MultiplierFactorNumeric must be a positive number</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:MultiplierFactorNumeric and ((cbc:Amount - (cbc:BaseAmount * cbc:MultiplierFactorNumeric) &lt; '-1.00') or (cbc:Amount - (cbc:BaseAmount * cbc:MultiplierFactorNumeric) > '1.00'))">
      <svrl:successful-report test="cbc:MultiplierFactorNumeric and ((cbc:Amount - (cbc:BaseAmount * cbc:MultiplierFactorNumeric) &lt; '-1.00') or (cbc:Amount - (cbc:BaseAmount * cbc:MultiplierFactorNumeric) > '1.00'))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB228] Amount must equal BaseAmount * MultiplierFactorNumeric</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AccountingCost and cbc:AccountingCostCode">
      <svrl:successful-report test="cbc:AccountingCost and cbc:AccountingCostCode">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB021] Use either AccountingCost or AccountingCostCode</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AllowanceChargeReason and cbc:AllowanceChargeReasonCode">
      <svrl:successful-report test="cbc:AllowanceChargeReason and cbc:AllowanceChargeReasonCode">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-REM094] Use either AllowanceChargeReason or AllowanceChargeReasonCode</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M27" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:AllowanceCharge/cbc:AllowanceChargeReasonCode" mode="M27" priority="1005">
    <svrl:fired-rule context="doc:Reminder/cac:AllowanceCharge/cbc:AllowanceChargeReasonCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="./@listID = 'urn:oioubl:codelist:reminderallowancechargereasoncode-1.0'" />
      <xsl:otherwise>
        <svrl:failed-assert test="./@listID = 'urn:oioubl:codelist:reminderallowancechargereasoncode-1.0'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[W-REM095] Invalid listID. Must be 'urn:oioubl:codelist:reminderallowancechargereasoncode-1.0'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="./@listAgencyID = '320'" />
      <xsl:otherwise>
        <svrl:failed-assert test="./@listAgencyID = '320'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[W-REM096] Invalid listAgencyID. Must be '320'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test=". = 'PenaltyFee' or . = 'PenaltyRate'" />
      <xsl:otherwise>
        <svrl:failed-assert test=". = 'PenaltyFee' or . = 'PenaltyRate'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-REM097] Invalid AllowanceChargeReasonCode. Must be a value from the codelist</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M27" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:AllowanceCharge/cbc:SequenceNumeric" mode="M27" priority="1004">
    <svrl:fired-rule context="doc:Reminder/cac:AllowanceCharge/cbc:SequenceNumeric" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(starts-with(.,'-'))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(starts-with(.,'-'))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB020] Invalid <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />. Must not be negative</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M27" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:AllowanceCharge/cbc:Amount" mode="M27" priority="1003">
    <svrl:fired-rule context="doc:Reminder/cac:AllowanceCharge/cbc:Amount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(starts-with(.,'-')) and . != 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(starts-with(.,'-')) and . != 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB019] Invalid <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />. Must not be negative or zero</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M27" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:AllowanceCharge/cbc:BaseAmount" mode="M27" priority="1002">
    <svrl:fired-rule context="doc:Reminder/cac:AllowanceCharge/cbc:BaseAmount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(starts-with(.,'-')) and . != 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(starts-with(.,'-')) and . != 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB019] Invalid <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />. Must not be negative or zero</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M27" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:AllowanceCharge/cac:TaxCategory" mode="M27" priority="1001">
    <svrl:fired-rule context="doc:Reminder/cac:AllowanceCharge/cac:TaxCategory" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:TierRange) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:TierRange) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB072] TierRange element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:TierRatePercent) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:TierRatePercent) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB073] TierRatePercent element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:ID) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:ID) != ''">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB074] Invalid TaxCategory/ID. Must contain a value.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID/@schemeID = $TaxCategory1_schemeID or cbc:ID/@schemeID = $TaxCategory2_schemeID or cbc:ID/@schemeID = $TaxCategory3_schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID/@schemeID = $TaxCategory1_schemeID or cbc:ID/@schemeID = $TaxCategory2_schemeID or cbc:ID/@schemeID = $TaxCategory3_schemeID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB075] Invalid schemeID. Must be either '<xsl:text />
            <xsl:value-of select="$TaxCategory1_schemeID" />
            <xsl:text />', '<xsl:text />
            <xsl:value-of select="$TaxCategory2_schemeID" />
            <xsl:text />' or '<xsl:text />
            <xsl:value-of select="$TaxCategory3_schemeID" />
            <xsl:text />'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID/@schemeAgencyID = $TaxCategory2_agencyID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID/@schemeAgencyID = $TaxCategory2_agencyID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[W-LIB229] Invalid schemeAgencyID. Must be '320'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="((cbc:ID/@schemeID = $TaxCategory1_schemeID) and not (contains($TaxCategory1, concat(',',cbc:ID,',')))) or ((cbc:ID/@schemeID = $TaxCategory2_schemeID) and not (contains($TaxCategory2, concat(',',cbc:ID,',')))) or ((cbc:ID/@schemeID = $TaxCategory3_schemeID) and not (contains($TaxCategory3, concat(',',cbc:ID,','))))">
      <svrl:successful-report test="((cbc:ID/@schemeID = $TaxCategory1_schemeID) and not (contains($TaxCategory1, concat(',',cbc:ID,',')))) or ((cbc:ID/@schemeID = $TaxCategory2_schemeID) and not (contains($TaxCategory2, concat(',',cbc:ID,',')))) or ((cbc:ID/@schemeID = $TaxCategory3_schemeID) and not (contains($TaxCategory3, concat(',',cbc:ID,','))))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB309] Invalid ID: '<xsl:text />
          <xsl:value-of select="cbc:ID" />
          <xsl:text />'. Must be a value from the codelist</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:Name != '') and not(contains(/doc:Invoice/cbc:ProfileID, 'nesubl.eu'))">
      <svrl:successful-report test="(cbc:Name != '') and not(contains(/doc:Invoice/cbc:ProfileID, 'nesubl.eu'))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[W-LIB230] Name should only be used within NES profiles</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:PerUnitAmount and cbc:Percent">
      <svrl:successful-report test="cbc:PerUnitAmount and cbc:Percent">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB231] Use either PerUnitAmount or Percent</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:PerUnitAmount and not(cbc:BaseUnitMeasure != '')">
      <svrl:successful-report test="cbc:PerUnitAmount and not(cbc:BaseUnitMeasure != '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB232] When PerUnitAmount is used, BaseUnitMeasure is mandatory</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M27" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme" mode="M27" priority="1000">
    <svrl:fired-rule context="doc:Reminder/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:ID) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:ID) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB041] ID element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:AddressTypeCode) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:AddressTypeCode) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB042] AddressTypeCode element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:Postbox) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:Postbox) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB043] Postbox element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:Floor) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:Floor) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB044] Floor element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:Room) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:Room) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB045] Room element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:StreetName) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:StreetName) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB046] StreetName element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:AdditionalStreetName) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:AdditionalStreetName) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB047] AdditionalStreetName element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:BlockName) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:BlockName) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB048] BlockName element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:BuildingName) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:BuildingName) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB049] BuildingName element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:BuildingNumber) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:BuildingNumber) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB050] BuildingNumber element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:InhouseMail) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:InhouseMail) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB051] InhouseMail element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:Department) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:Department) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB052] Department element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:MarkAttention) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:MarkAttention) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB053] MarkAttention element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:MarkCare) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:MarkCare) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB054] MarkCare element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:PlotIdentification) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:PlotIdentification) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB055] PlotIdentification element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:CitySubdivisionName) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:CitySubdivisionName) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB056] CitySubdivisionName element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:CityName) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:CityName) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB057] CityName element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:PostalZone) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:PostalZone) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB058] PostalZone element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:CountrySubentity) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:CountrySubentity) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB059] CountrySubentity element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:CountrySubentityCode) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:CountrySubentityCode) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB060] CountrySubentityCode element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:TimezoneOffset) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:TimezoneOffset) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB063] TimezoneOffset element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cac:AddressLine) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cac:AddressLine) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB234] AddressLine class must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cac:LocationCoordinate) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cac:LocationCoordinate) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB064] LocationCoordinate class must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:ID = '63') and cbc:TaxTypeCode">
      <svrl:successful-report test="(cbc:ID = '63') and cbc:TaxTypeCode">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB067] TaxTypeCode is not allowed when TaxScheme/ID equals '63' (Moms)</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:ID) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:ID) != ''">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB065] Invalid TaxScheme/ID. Must contain a value.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:Name) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:Name) != ''">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB066] Invalid Name. Must contain a value</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="not((cbc:ID = '63' or cbc:ID = 'VAT')) and not(contains($TaxType2, concat(',',cbc:TaxTypeCode,',')))">
      <svrl:successful-report test="not((cbc:ID = '63' or cbc:ID = 'VAT')) and not(contains($TaxType2, concat(',',cbc:TaxTypeCode,',')))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB197] TaxTypeCode must be a value from the '<xsl:text />
          <xsl:value-of select="$TaxType_listID2" />
          <xsl:text />' codelist when TaxScheme/ID is different from '63' or 'VAT' (Moms)</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID/@schemeID = $TaxScheme_schemeID or cbc:ID/@schemeID = $TaxScheme2_schemeID or cbc:ID/@schemeID = $TaxScheme4_schemeID or cbc:ID/@schemeID = $TaxScheme5_schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID/@schemeID = $TaxScheme_schemeID or cbc:ID/@schemeID = $TaxScheme2_schemeID or cbc:ID/@schemeID = $TaxScheme4_schemeID or cbc:ID/@schemeID = $TaxScheme5_schemeID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB070] Invalid schemeID. Must be either '<xsl:text />
            <xsl:value-of select="$TaxScheme_schemeID" />
            <xsl:text />', '<xsl:text />
            <xsl:value-of select="$TaxScheme2_schemeID" />
            <xsl:text />', '<xsl:text />
            <xsl:value-of select="$TaxScheme4_schemeID" />
            <xsl:text />' or '<xsl:text />
            <xsl:value-of select="$TaxScheme5_schemeID" />
            <xsl:text />'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:TaxTypeCode) and not((cbc:TaxTypeCode/@listID = $TaxType_listID) or (cbc:TaxTypeCode/@listID = $TaxType_listID2))">
      <svrl:successful-report test="(cbc:TaxTypeCode) and not((cbc:TaxTypeCode/@listID = $TaxType_listID) or (cbc:TaxTypeCode/@listID = $TaxType_listID2))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB071] Invalid listID. Must be either '<xsl:text />
          <xsl:value-of select="$TaxType_listID" />
          <xsl:text />' or '<xsl:text />
          <xsl:value-of select="$TaxType_listID2" />
          <xsl:text />'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID = '63') and cbc:Name != 'Moms'">
      <svrl:successful-report test="(cbc:ID = '63') and cbc:Name != 'Moms'">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB198] Name must equal 'Moms' when TaxScheme/ID equals '63' (Moms)</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID != '63') and cbc:Name = 'Moms'">
      <svrl:successful-report test="(cbc:ID != '63') and cbc:Name = 'Moms'">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB199] Name must correspond to the value of TaxScheme/ID</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cac:JurisdictionRegionAddress/cac:Country/cbc:IdentificationCode) and not(contains($CountryCode, concat(',',cac:JurisdictionRegionAddress/cac:Country/cbc:IdentificationCode,',')))">
      <svrl:successful-report test="(cac:JurisdictionRegionAddress/cac:Country/cbc:IdentificationCode) and not(contains($CountryCode, concat(',',cac:JurisdictionRegionAddress/cac:Country/cbc:IdentificationCode,',')))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB337] Invalid Country/IdentificationCode: '<xsl:text />
          <xsl:value-of select="cac:JurisdictionRegionAddress/cac:Country/cbc:IdentificationCode" />
          <xsl:text />'. Must be a value from the country codelist</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cac:JurisdictionRegionAddress) and cac:JurisdictionRegionAddress/cbc:AddressFormatCode != 'StructuredRegion'">
      <svrl:successful-report test="(cac:JurisdictionRegionAddress) and cac:JurisdictionRegionAddress/cbc:AddressFormatCode != 'StructuredRegion'">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB233] The AddressFormatCode under JurisdictionRegionAddress must always equal 'StructuredRegion'</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M27" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M27" priority="-1" />
  <xsl:template match="@*|node()" mode="M27" priority="-2">
    <xsl:apply-templates mode="M27" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN taxexchangerate-->


	<!--RULE -->
<xsl:template match="doc:Reminder/cac:TaxExchangeRate" mode="M28" priority="1003">
    <svrl:fired-rule context="doc:Reminder/cac:TaxExchangeRate" />

		<!--REPORT -->
<xsl:if test="cac:ForeignExchangeContract and not(normalize-space(cac:ForeignExchangeContract/cbc:ID) != '')">
      <svrl:successful-report test="cac:ForeignExchangeContract and not(normalize-space(cac:ForeignExchangeContract/cbc:ID) != '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB238] Invalid TaxExchangeRate/ForeignExchangeRate/ID. Must contain a value.</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:SourceCurrencyCode) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:SourceCurrencyCode) != ''">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB083] Invalid SourceCurrencyCode. Must contain a value</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:TargetCurrencyCode) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:TargetCurrencyCode) != ''">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB084] Invalid TargetCurrencyCode. Must contain a value</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="cbc:SourceCurrencyBaseRate and (starts-with(cbc:SourceCurrencyBaseRate,'-') or cbc:SourceCurrencyBaseRate = 0)">
      <svrl:successful-report test="cbc:SourceCurrencyBaseRate and (starts-with(cbc:SourceCurrencyBaseRate,'-') or cbc:SourceCurrencyBaseRate = 0)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB085] Invalid SourceCurrencyBaseRate. Must not be negative or zero</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:SourceCurrencyBaseRate and string-length(substring-after(cbc:SourceCurrencyBaseRate, '.')) != 4">
      <svrl:successful-report test="cbc:SourceCurrencyBaseRate and string-length(substring-after(cbc:SourceCurrencyBaseRate, '.')) != 4">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB086] Invalid SourceCurrencyBaseRate. Must have 4 decimals</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:TargetCurrencyBaseRate and (starts-with(cbc:TargetCurrencyBaseRate,'-') or cbc:TargetCurrencyBaseRate = 0)">
      <svrl:successful-report test="cbc:TargetCurrencyBaseRate and (starts-with(cbc:TargetCurrencyBaseRate,'-') or cbc:TargetCurrencyBaseRate = 0)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB087] Invalid TargetCurrencyBaseRate. Must not be negative or zero</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:TargetCurrencyBaseRate and string-length(substring-after(cbc:TargetCurrencyBaseRate, '.')) != 4">
      <svrl:successful-report test="cbc:TargetCurrencyBaseRate and string-length(substring-after(cbc:TargetCurrencyBaseRate, '.')) != 4">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB088] Invalid TargetCurrencyBaseRate. Must have 4 decimals</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:CalculationRate and (starts-with(cbc:CalculationRate,'-') or cbc:CalculationRate = 0)">
      <svrl:successful-report test="cbc:CalculationRate and (starts-with(cbc:CalculationRate,'-') or cbc:CalculationRate = 0)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB089] Invalid CalculationRate. Must not be negative or zero</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:CalculationRate and string-length(substring-after(cbc:CalculationRate, '.')) != 4">
      <svrl:successful-report test="cbc:CalculationRate and string-length(substring-after(cbc:CalculationRate, '.')) != 4">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB090] Invalid CalculationRate. Must have 4 decimals</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:MathematicOperatorCode != 'multiply' and cbc:MathematicOperatorCode != 'divide'">
      <svrl:successful-report test="cbc:MathematicOperatorCode != 'multiply' and cbc:MathematicOperatorCode != 'divide'">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB310] Invalid MathematicOperatorCode. Must either be 'multiply' or 'divide'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:ForeignExchangeContract/cbc:ContractTypeCode and cac:ForeignExchangeContract/cbc:ContractType">
      <svrl:successful-report test="cac:ForeignExchangeContract/cbc:ContractTypeCode and cac:ForeignExchangeContract/cbc:ContractType">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB239] Use either ContractTypeCode or ContractType</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="count(cac:ForeignExchangeContract/cac:ContractDocumentReference) > 1">
      <svrl:successful-report test="count(cac:ForeignExchangeContract/cac:ContractDocumentReference) > 1">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB240] No more than one ContractDocumentReference class may be present</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M28" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:TaxExchangeRate/cac:ForeignExchangeContract/cac:ValidityPeriod" mode="M28" priority="1002">
    <svrl:fired-rule context="doc:Reminder/cac:TaxExchangeRate/cac:ForeignExchangeContract/cac:ValidityPeriod" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:DurationMeasure) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:DurationMeasure) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB076] DurationMeasure element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:DescriptionCode) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:DescriptionCode) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB077] DescriptionCode element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:StartTime) and (not(cbc:StartDate) or cbc:StartDate = '')">
      <svrl:successful-report test="(cbc:StartTime) and (not(cbc:StartDate) or cbc:StartDate = '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB078] There must be a StartDate if you have a StartTime</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:EndTime) and (not(cbc:EndDate) or cbc:EndDate = '')">
      <svrl:successful-report test="(cbc:EndTime) and (not(cbc:EndDate) or cbc:EndDate = '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB079] There must be a EndDate if you have a EndTime</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:StartDate and cbc:EndDate) and not(number(translate(cbc:EndDate,'-','')) > number(translate(cbc:StartDate,'-','')) or number(translate(cbc:EndDate,'-','')) = number(translate(cbc:StartDate,'-','')))">
      <svrl:successful-report test="(cbc:StartDate and cbc:EndDate) and not(number(translate(cbc:EndDate,'-','')) > number(translate(cbc:StartDate,'-','')) or number(translate(cbc:EndDate,'-','')) = number(translate(cbc:StartDate,'-','')))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB080] The EndDate must be greater or equal to the startdate</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:StartTime and cbc:EndTime) and not(number(translate(cbc:EndTime,':','')) > number(translate(cbc:StartTime,':','')) or number(translate(cbc:EndTime,':','')) = number(translate(cbc:StartTime,':','')))">
      <svrl:successful-report test="(cbc:StartTime and cbc:EndTime) and not(number(translate(cbc:EndTime,':','')) > number(translate(cbc:StartTime,':','')) or number(translate(cbc:EndTime,':','')) = number(translate(cbc:StartTime,':','')))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB081] EndTime must be greater or equal to StartTime</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M28" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:TaxExchangeRate/cac:ForeignExchangeContract/cac:ValidityPeriod/cbc:Description" mode="M28" priority="1001">
    <svrl:fired-rule context="doc:Reminder/cac:TaxExchangeRate/cac:ForeignExchangeContract/cac:ValidityPeriod/cbc:Description" />

		<!--REPORT -->
<xsl:if test="count(../cbc:Description) > 1 and not(./@languageID)">
      <svrl:successful-report test="count(../cbc:Description) > 1 and not(./@languageID)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[W-LIB222] The attribute languageID should be used when more than one Description element is present</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID">
      <svrl:successful-report test="local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[W-LIB223] Multilanguage error. Replicated Description elements with same languageID attribute value</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M28" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:TaxExchangeRate/cac:ForeignExchangeContract/cac:ContractDocumentReference" mode="M28" priority="1000">
    <svrl:fired-rule context="doc:Reminder/cac:TaxExchangeRate/cac:ForeignExchangeContract/cac:ContractDocumentReference" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:DocumentType) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:DocumentType) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB170] DocumentType element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:DocumentTypeCode) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:DocumentTypeCode) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB172] DocumentTypeCode element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="cac:Attachment and cbc:XPath">
      <svrl:successful-report test="cac:Attachment and cbc:XPath">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB169] Use either Attachment or XPath</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Attachment/cbc:EmbeddedDocumentBinaryObject and cac:Attachment/cac:ExternalReference">
      <svrl:successful-report test="cac:Attachment/cbc:EmbeddedDocumentBinaryObject and cac:Attachment/cac:ExternalReference">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB171] Use either EmbeddedDocumentBinaryObject or ExternalReference</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:UUID and not(string-length(string(cbc:UUID)) = 36)">
      <svrl:successful-report test="cbc:UUID and not(string-length(string(cbc:UUID)) = 36)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB173] Invalid UUID. Must be of this form '6E09886B-DC6E-439F-82D1-7CCAC7F4E3B1'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Attachment/cbc:EmbeddedDocumentBinaryObject and not(cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/tiff' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/png' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/jpeg' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/gif' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/pdf' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='text/xml' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='text/csv' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.ms-excel' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.oasis.opendocument.spreadsheet')">
      <svrl:successful-report test="cac:Attachment/cbc:EmbeddedDocumentBinaryObject and not(cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/tiff' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/png' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/jpeg' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/gif' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/pdf' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='text/xml' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='text/csv' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.ms-excel' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.oasis.opendocument.spreadsheet')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB174] Attribute mimeCode must be a value from the codelist</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Attachment/cac:ExternalReference and not(cac:Attachment/cac:ExternalReference/cbc:URI != '')">
      <svrl:successful-report test="cac:Attachment/cac:ExternalReference and not(cac:Attachment/cac:ExternalReference/cbc:URI != '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB096] When using ExternalReference, URI is mandatory</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M28" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M28" priority="-1" />
  <xsl:template match="@*|node()" mode="M28" priority="-2">
    <xsl:apply-templates mode="M28" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN pricingexchangerate-->


	<!--RULE -->
<xsl:template match="doc:Reminder/cac:PricingExchangeRate" mode="M29" priority="1003">
    <svrl:fired-rule context="doc:Reminder/cac:PricingExchangeRate" />

		<!--REPORT -->
<xsl:if test="cac:ForeignExchangeContract and not(normalize-space(cac:ForeignExchangeContract/cbc:ID) != '')">
      <svrl:successful-report test="cac:ForeignExchangeContract and not(normalize-space(cac:ForeignExchangeContract/cbc:ID) != '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB238] Invalid TaxExchangeRate/ForeignExchangeRate/ID. Must contain a value.</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:SourceCurrencyCode) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:SourceCurrencyCode) != ''">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB083] Invalid SourceCurrencyCode. Must contain a value</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:TargetCurrencyCode) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:TargetCurrencyCode) != ''">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB084] Invalid TargetCurrencyCode. Must contain a value</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="cbc:SourceCurrencyBaseRate and (starts-with(cbc:SourceCurrencyBaseRate,'-') or cbc:SourceCurrencyBaseRate = 0)">
      <svrl:successful-report test="cbc:SourceCurrencyBaseRate and (starts-with(cbc:SourceCurrencyBaseRate,'-') or cbc:SourceCurrencyBaseRate = 0)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB085] Invalid SourceCurrencyBaseRate. Must not be negative or zero</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:SourceCurrencyBaseRate and string-length(substring-after(cbc:SourceCurrencyBaseRate, '.')) != 4">
      <svrl:successful-report test="cbc:SourceCurrencyBaseRate and string-length(substring-after(cbc:SourceCurrencyBaseRate, '.')) != 4">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB086] Invalid SourceCurrencyBaseRate. Must have 4 decimals</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:TargetCurrencyBaseRate and (starts-with(cbc:TargetCurrencyBaseRate,'-') or cbc:TargetCurrencyBaseRate = 0)">
      <svrl:successful-report test="cbc:TargetCurrencyBaseRate and (starts-with(cbc:TargetCurrencyBaseRate,'-') or cbc:TargetCurrencyBaseRate = 0)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB087] Invalid TargetCurrencyBaseRate. Must not be negative or zero</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:TargetCurrencyBaseRate and string-length(substring-after(cbc:TargetCurrencyBaseRate, '.')) != 4">
      <svrl:successful-report test="cbc:TargetCurrencyBaseRate and string-length(substring-after(cbc:TargetCurrencyBaseRate, '.')) != 4">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB088] Invalid TargetCurrencyBaseRate. Must have 4 decimals</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:CalculationRate and (starts-with(cbc:CalculationRate,'-') or cbc:CalculationRate = 0)">
      <svrl:successful-report test="cbc:CalculationRate and (starts-with(cbc:CalculationRate,'-') or cbc:CalculationRate = 0)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB089] Invalid CalculationRate. Must not be negative or zero</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:CalculationRate and string-length(substring-after(cbc:CalculationRate, '.')) != 4">
      <svrl:successful-report test="cbc:CalculationRate and string-length(substring-after(cbc:CalculationRate, '.')) != 4">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB090] Invalid CalculationRate. Must have 4 decimals</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:MathematicOperatorCode != 'multiply' and cbc:MathematicOperatorCode != 'divide'">
      <svrl:successful-report test="cbc:MathematicOperatorCode != 'multiply' and cbc:MathematicOperatorCode != 'divide'">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB310] Invalid MathematicOperatorCode. Must either be 'multiply' or 'divide'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:ForeignExchangeContract/cbc:ContractTypeCode and cac:ForeignExchangeContract/cbc:ContractType">
      <svrl:successful-report test="cac:ForeignExchangeContract/cbc:ContractTypeCode and cac:ForeignExchangeContract/cbc:ContractType">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB239] Use either ContractTypeCode or ContractType</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="count(cac:ForeignExchangeContract/cac:ContractDocumentReference) > 1">
      <svrl:successful-report test="count(cac:ForeignExchangeContract/cac:ContractDocumentReference) > 1">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB240] No more than one ContractDocumentReference class may be present</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M29" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:PricingExchangeRate/cac:ForeignExchangeContract/cac:ValidityPeriod" mode="M29" priority="1002">
    <svrl:fired-rule context="doc:Reminder/cac:PricingExchangeRate/cac:ForeignExchangeContract/cac:ValidityPeriod" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:DurationMeasure) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:DurationMeasure) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB076] DurationMeasure element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:DescriptionCode) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:DescriptionCode) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB077] DescriptionCode element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:StartTime) and (not(cbc:StartDate) or cbc:StartDate = '')">
      <svrl:successful-report test="(cbc:StartTime) and (not(cbc:StartDate) or cbc:StartDate = '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB078] There must be a StartDate if you have a StartTime</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:EndTime) and (not(cbc:EndDate) or cbc:EndDate = '')">
      <svrl:successful-report test="(cbc:EndTime) and (not(cbc:EndDate) or cbc:EndDate = '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB079] There must be a EndDate if you have a EndTime</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:StartDate and cbc:EndDate) and not(number(translate(cbc:EndDate,'-','')) > number(translate(cbc:StartDate,'-','')) or number(translate(cbc:EndDate,'-','')) = number(translate(cbc:StartDate,'-','')))">
      <svrl:successful-report test="(cbc:StartDate and cbc:EndDate) and not(number(translate(cbc:EndDate,'-','')) > number(translate(cbc:StartDate,'-','')) or number(translate(cbc:EndDate,'-','')) = number(translate(cbc:StartDate,'-','')))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB080] The EndDate must be greater or equal to the startdate</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:StartTime and cbc:EndTime) and not(number(translate(cbc:EndTime,':','')) > number(translate(cbc:StartTime,':','')) or number(translate(cbc:EndTime,':','')) = number(translate(cbc:StartTime,':','')))">
      <svrl:successful-report test="(cbc:StartTime and cbc:EndTime) and not(number(translate(cbc:EndTime,':','')) > number(translate(cbc:StartTime,':','')) or number(translate(cbc:EndTime,':','')) = number(translate(cbc:StartTime,':','')))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB081] EndTime must be greater or equal to StartTime</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M29" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:PricingExchangeRate/cac:ForeignExchangeContract/cac:ValidityPeriod/cbc:Description" mode="M29" priority="1001">
    <svrl:fired-rule context="doc:Reminder/cac:PricingExchangeRate/cac:ForeignExchangeContract/cac:ValidityPeriod/cbc:Description" />

		<!--REPORT -->
<xsl:if test="count(../cbc:Description) > 1 and not(./@languageID)">
      <svrl:successful-report test="count(../cbc:Description) > 1 and not(./@languageID)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[W-LIB222] The attribute languageID should be used when more than one Description element is present</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID">
      <svrl:successful-report test="local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[W-LIB223] Multilanguage error. Replicated Description elements with same languageID attribute value</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M29" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:PricingExchangeRate/cac:ForeignExchangeContract/cac:ContractDocumentReference" mode="M29" priority="1000">
    <svrl:fired-rule context="doc:Reminder/cac:PricingExchangeRate/cac:ForeignExchangeContract/cac:ContractDocumentReference" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:DocumentType) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:DocumentType) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB170] DocumentType element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:DocumentTypeCode) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:DocumentTypeCode) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB172] DocumentTypeCode element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="cac:Attachment and cbc:XPath">
      <svrl:successful-report test="cac:Attachment and cbc:XPath">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB169] Use either Attachment or XPath</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Attachment/cbc:EmbeddedDocumentBinaryObject and cac:Attachment/cac:ExternalReference">
      <svrl:successful-report test="cac:Attachment/cbc:EmbeddedDocumentBinaryObject and cac:Attachment/cac:ExternalReference">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB171] Use either EmbeddedDocumentBinaryObject or ExternalReference</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:UUID and not(string-length(string(cbc:UUID)) = 36)">
      <svrl:successful-report test="cbc:UUID and not(string-length(string(cbc:UUID)) = 36)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB173] Invalid UUID. Must be of this form '6E09886B-DC6E-439F-82D1-7CCAC7F4E3B1'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Attachment/cbc:EmbeddedDocumentBinaryObject and not(cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/tiff' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/png' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/jpeg' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/gif' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/pdf' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='text/xml' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='text/csv' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.ms-excel' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.oasis.opendocument.spreadsheet')">
      <svrl:successful-report test="cac:Attachment/cbc:EmbeddedDocumentBinaryObject and not(cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/tiff' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/png' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/jpeg' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/gif' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/pdf' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='text/xml' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='text/csv' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.ms-excel' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.oasis.opendocument.spreadsheet')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB174] Attribute mimeCode must be a value from the codelist</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Attachment/cac:ExternalReference and not(cac:Attachment/cac:ExternalReference/cbc:URI != '')">
      <svrl:successful-report test="cac:Attachment/cac:ExternalReference and not(cac:Attachment/cac:ExternalReference/cbc:URI != '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB096] When using ExternalReference, URI is mandatory</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M29" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M29" priority="-1" />
  <xsl:template match="@*|node()" mode="M29" priority="-2">
    <xsl:apply-templates mode="M29" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN paymentexchangerate-->


	<!--RULE -->
<xsl:template match="doc:Reminder/cac:PaymentExchangeRate" mode="M30" priority="1003">
    <svrl:fired-rule context="doc:Reminder/cac:PaymentExchangeRate" />

		<!--REPORT -->
<xsl:if test="cac:ForeignExchangeContract and not(normalize-space(cac:ForeignExchangeContract/cbc:ID) != '')">
      <svrl:successful-report test="cac:ForeignExchangeContract and not(normalize-space(cac:ForeignExchangeContract/cbc:ID) != '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB238] Invalid TaxExchangeRate/ForeignExchangeRate/ID. Must contain a value.</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:SourceCurrencyCode) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:SourceCurrencyCode) != ''">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB083] Invalid SourceCurrencyCode. Must contain a value</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:TargetCurrencyCode) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:TargetCurrencyCode) != ''">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB084] Invalid TargetCurrencyCode. Must contain a value</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="cbc:SourceCurrencyBaseRate and (starts-with(cbc:SourceCurrencyBaseRate,'-') or cbc:SourceCurrencyBaseRate = 0)">
      <svrl:successful-report test="cbc:SourceCurrencyBaseRate and (starts-with(cbc:SourceCurrencyBaseRate,'-') or cbc:SourceCurrencyBaseRate = 0)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB085] Invalid SourceCurrencyBaseRate. Must not be negative or zero</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:SourceCurrencyBaseRate and string-length(substring-after(cbc:SourceCurrencyBaseRate, '.')) != 4">
      <svrl:successful-report test="cbc:SourceCurrencyBaseRate and string-length(substring-after(cbc:SourceCurrencyBaseRate, '.')) != 4">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB086] Invalid SourceCurrencyBaseRate. Must have 4 decimals</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:TargetCurrencyBaseRate and (starts-with(cbc:TargetCurrencyBaseRate,'-') or cbc:TargetCurrencyBaseRate = 0)">
      <svrl:successful-report test="cbc:TargetCurrencyBaseRate and (starts-with(cbc:TargetCurrencyBaseRate,'-') or cbc:TargetCurrencyBaseRate = 0)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB087] Invalid TargetCurrencyBaseRate. Must not be negative or zero</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:TargetCurrencyBaseRate and string-length(substring-after(cbc:TargetCurrencyBaseRate, '.')) != 4">
      <svrl:successful-report test="cbc:TargetCurrencyBaseRate and string-length(substring-after(cbc:TargetCurrencyBaseRate, '.')) != 4">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB088] Invalid TargetCurrencyBaseRate. Must have 4 decimals</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:CalculationRate and (starts-with(cbc:CalculationRate,'-') or cbc:CalculationRate = 0)">
      <svrl:successful-report test="cbc:CalculationRate and (starts-with(cbc:CalculationRate,'-') or cbc:CalculationRate = 0)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB089] Invalid CalculationRate. Must not be negative or zero</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:CalculationRate and string-length(substring-after(cbc:CalculationRate, '.')) != 4">
      <svrl:successful-report test="cbc:CalculationRate and string-length(substring-after(cbc:CalculationRate, '.')) != 4">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB090] Invalid CalculationRate. Must have 4 decimals</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:MathematicOperatorCode != 'multiply' and cbc:MathematicOperatorCode != 'divide'">
      <svrl:successful-report test="cbc:MathematicOperatorCode != 'multiply' and cbc:MathematicOperatorCode != 'divide'">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB310] Invalid MathematicOperatorCode. Must either be 'multiply' or 'divide'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:ForeignExchangeContract/cbc:ContractTypeCode and cac:ForeignExchangeContract/cbc:ContractType">
      <svrl:successful-report test="cac:ForeignExchangeContract/cbc:ContractTypeCode and cac:ForeignExchangeContract/cbc:ContractType">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB239] Use either ContractTypeCode or ContractType</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="count(cac:ForeignExchangeContract/cac:ContractDocumentReference) > 1">
      <svrl:successful-report test="count(cac:ForeignExchangeContract/cac:ContractDocumentReference) > 1">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB240] No more than one ContractDocumentReference class may be present</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M30" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:PaymentExchangeRate/cac:ForeignExchangeContract/cac:ValidityPeriod" mode="M30" priority="1002">
    <svrl:fired-rule context="doc:Reminder/cac:PaymentExchangeRate/cac:ForeignExchangeContract/cac:ValidityPeriod" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:DurationMeasure) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:DurationMeasure) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB076] DurationMeasure element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:DescriptionCode) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:DescriptionCode) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB077] DescriptionCode element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:StartTime) and (not(cbc:StartDate) or cbc:StartDate = '')">
      <svrl:successful-report test="(cbc:StartTime) and (not(cbc:StartDate) or cbc:StartDate = '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB078] There must be a StartDate if you have a StartTime</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:EndTime) and (not(cbc:EndDate) or cbc:EndDate = '')">
      <svrl:successful-report test="(cbc:EndTime) and (not(cbc:EndDate) or cbc:EndDate = '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB079] There must be a EndDate if you have a EndTime</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:StartDate and cbc:EndDate) and not(number(translate(cbc:EndDate,'-','')) > number(translate(cbc:StartDate,'-','')) or number(translate(cbc:EndDate,'-','')) = number(translate(cbc:StartDate,'-','')))">
      <svrl:successful-report test="(cbc:StartDate and cbc:EndDate) and not(number(translate(cbc:EndDate,'-','')) > number(translate(cbc:StartDate,'-','')) or number(translate(cbc:EndDate,'-','')) = number(translate(cbc:StartDate,'-','')))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB080] The EndDate must be greater or equal to the startdate</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:StartTime and cbc:EndTime) and not(number(translate(cbc:EndTime,':','')) > number(translate(cbc:StartTime,':','')) or number(translate(cbc:EndTime,':','')) = number(translate(cbc:StartTime,':','')))">
      <svrl:successful-report test="(cbc:StartTime and cbc:EndTime) and not(number(translate(cbc:EndTime,':','')) > number(translate(cbc:StartTime,':','')) or number(translate(cbc:EndTime,':','')) = number(translate(cbc:StartTime,':','')))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB081] EndTime must be greater or equal to StartTime</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M30" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:PaymentExchangeRate/cac:ForeignExchangeContract/cac:ValidityPeriod/cbc:Description" mode="M30" priority="1001">
    <svrl:fired-rule context="doc:Reminder/cac:PaymentExchangeRate/cac:ForeignExchangeContract/cac:ValidityPeriod/cbc:Description" />

		<!--REPORT -->
<xsl:if test="count(../cbc:Description) > 1 and not(./@languageID)">
      <svrl:successful-report test="count(../cbc:Description) > 1 and not(./@languageID)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[W-LIB222] The attribute languageID should be used when more than one Description element is present</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID">
      <svrl:successful-report test="local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[W-LIB223] Multilanguage error. Replicated Description elements with same languageID attribute value</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M30" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:PaymentExchangeRate/cac:ForeignExchangeContract/cac:ContractDocumentReference" mode="M30" priority="1000">
    <svrl:fired-rule context="doc:Reminder/cac:PaymentExchangeRate/cac:ForeignExchangeContract/cac:ContractDocumentReference" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:DocumentType) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:DocumentType) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB170] DocumentType element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:DocumentTypeCode) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:DocumentTypeCode) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB172] DocumentTypeCode element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="cac:Attachment and cbc:XPath">
      <svrl:successful-report test="cac:Attachment and cbc:XPath">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB169] Use either Attachment or XPath</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Attachment/cbc:EmbeddedDocumentBinaryObject and cac:Attachment/cac:ExternalReference">
      <svrl:successful-report test="cac:Attachment/cbc:EmbeddedDocumentBinaryObject and cac:Attachment/cac:ExternalReference">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB171] Use either EmbeddedDocumentBinaryObject or ExternalReference</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:UUID and not(string-length(string(cbc:UUID)) = 36)">
      <svrl:successful-report test="cbc:UUID and not(string-length(string(cbc:UUID)) = 36)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB173] Invalid UUID. Must be of this form '6E09886B-DC6E-439F-82D1-7CCAC7F4E3B1'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Attachment/cbc:EmbeddedDocumentBinaryObject and not(cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/tiff' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/png' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/jpeg' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/gif' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/pdf' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='text/xml' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='text/csv' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.ms-excel' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.oasis.opendocument.spreadsheet')">
      <svrl:successful-report test="cac:Attachment/cbc:EmbeddedDocumentBinaryObject and not(cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/tiff' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/png' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/jpeg' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/gif' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/pdf' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='text/xml' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='text/csv' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.ms-excel' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.oasis.opendocument.spreadsheet')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB174] Attribute mimeCode must be a value from the codelist</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Attachment/cac:ExternalReference and not(cac:Attachment/cac:ExternalReference/cbc:URI != '')">
      <svrl:successful-report test="cac:Attachment/cac:ExternalReference and not(cac:Attachment/cac:ExternalReference/cbc:URI != '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB096] When using ExternalReference, URI is mandatory</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M30" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M30" priority="-1" />
  <xsl:template match="@*|node()" mode="M30" priority="-2">
    <xsl:apply-templates mode="M30" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN paymentalternativeexchangerate-->


	<!--RULE -->
<xsl:template match="doc:Reminder/cac:PaymentAlternativeExchangeRate" mode="M31" priority="1003">
    <svrl:fired-rule context="doc:Reminder/cac:PaymentAlternativeExchangeRate" />

		<!--REPORT -->
<xsl:if test="cac:ForeignExchangeContract and not(normalize-space(cac:ForeignExchangeContract/cbc:ID) != '')">
      <svrl:successful-report test="cac:ForeignExchangeContract and not(normalize-space(cac:ForeignExchangeContract/cbc:ID) != '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB238] Invalid TaxExchangeRate/ForeignExchangeRate/ID. Must contain a value.</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:SourceCurrencyCode) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:SourceCurrencyCode) != ''">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB083] Invalid SourceCurrencyCode. Must contain a value</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:TargetCurrencyCode) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:TargetCurrencyCode) != ''">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB084] Invalid TargetCurrencyCode. Must contain a value</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="cbc:SourceCurrencyBaseRate and (starts-with(cbc:SourceCurrencyBaseRate,'-') or cbc:SourceCurrencyBaseRate = 0)">
      <svrl:successful-report test="cbc:SourceCurrencyBaseRate and (starts-with(cbc:SourceCurrencyBaseRate,'-') or cbc:SourceCurrencyBaseRate = 0)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB085] Invalid SourceCurrencyBaseRate. Must not be negative or zero</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:SourceCurrencyBaseRate and string-length(substring-after(cbc:SourceCurrencyBaseRate, '.')) != 4">
      <svrl:successful-report test="cbc:SourceCurrencyBaseRate and string-length(substring-after(cbc:SourceCurrencyBaseRate, '.')) != 4">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB086] Invalid SourceCurrencyBaseRate. Must have 4 decimals</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:TargetCurrencyBaseRate and (starts-with(cbc:TargetCurrencyBaseRate,'-') or cbc:TargetCurrencyBaseRate = 0)">
      <svrl:successful-report test="cbc:TargetCurrencyBaseRate and (starts-with(cbc:TargetCurrencyBaseRate,'-') or cbc:TargetCurrencyBaseRate = 0)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB087] Invalid TargetCurrencyBaseRate. Must not be negative or zero</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:TargetCurrencyBaseRate and string-length(substring-after(cbc:TargetCurrencyBaseRate, '.')) != 4">
      <svrl:successful-report test="cbc:TargetCurrencyBaseRate and string-length(substring-after(cbc:TargetCurrencyBaseRate, '.')) != 4">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB088] Invalid TargetCurrencyBaseRate. Must have 4 decimals</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:CalculationRate and (starts-with(cbc:CalculationRate,'-') or cbc:CalculationRate = 0)">
      <svrl:successful-report test="cbc:CalculationRate and (starts-with(cbc:CalculationRate,'-') or cbc:CalculationRate = 0)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB089] Invalid CalculationRate. Must not be negative or zero</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:CalculationRate and string-length(substring-after(cbc:CalculationRate, '.')) != 4">
      <svrl:successful-report test="cbc:CalculationRate and string-length(substring-after(cbc:CalculationRate, '.')) != 4">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB090] Invalid CalculationRate. Must have 4 decimals</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:MathematicOperatorCode != 'multiply' and cbc:MathematicOperatorCode != 'divide'">
      <svrl:successful-report test="cbc:MathematicOperatorCode != 'multiply' and cbc:MathematicOperatorCode != 'divide'">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB310] Invalid MathematicOperatorCode. Must either be 'multiply' or 'divide'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:ForeignExchangeContract/cbc:ContractTypeCode and cac:ForeignExchangeContract/cbc:ContractType">
      <svrl:successful-report test="cac:ForeignExchangeContract/cbc:ContractTypeCode and cac:ForeignExchangeContract/cbc:ContractType">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB239] Use either ContractTypeCode or ContractType</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="count(cac:ForeignExchangeContract/cac:ContractDocumentReference) > 1">
      <svrl:successful-report test="count(cac:ForeignExchangeContract/cac:ContractDocumentReference) > 1">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB240] No more than one ContractDocumentReference class may be present</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M31" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:PaymentAlternativeExchangeRate/cac:ForeignExchangeContract/cac:ValidityPeriod" mode="M31" priority="1002">
    <svrl:fired-rule context="doc:Reminder/cac:PaymentAlternativeExchangeRate/cac:ForeignExchangeContract/cac:ValidityPeriod" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:DurationMeasure) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:DurationMeasure) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB076] DurationMeasure element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:DescriptionCode) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:DescriptionCode) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB077] DescriptionCode element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:StartTime) and (not(cbc:StartDate) or cbc:StartDate = '')">
      <svrl:successful-report test="(cbc:StartTime) and (not(cbc:StartDate) or cbc:StartDate = '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB078] There must be a StartDate if you have a StartTime</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:EndTime) and (not(cbc:EndDate) or cbc:EndDate = '')">
      <svrl:successful-report test="(cbc:EndTime) and (not(cbc:EndDate) or cbc:EndDate = '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB079] There must be a EndDate if you have a EndTime</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:StartDate and cbc:EndDate) and not(number(translate(cbc:EndDate,'-','')) > number(translate(cbc:StartDate,'-','')) or number(translate(cbc:EndDate,'-','')) = number(translate(cbc:StartDate,'-','')))">
      <svrl:successful-report test="(cbc:StartDate and cbc:EndDate) and not(number(translate(cbc:EndDate,'-','')) > number(translate(cbc:StartDate,'-','')) or number(translate(cbc:EndDate,'-','')) = number(translate(cbc:StartDate,'-','')))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB080] The EndDate must be greater or equal to the startdate</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:StartTime and cbc:EndTime) and not(number(translate(cbc:EndTime,':','')) > number(translate(cbc:StartTime,':','')) or number(translate(cbc:EndTime,':','')) = number(translate(cbc:StartTime,':','')))">
      <svrl:successful-report test="(cbc:StartTime and cbc:EndTime) and not(number(translate(cbc:EndTime,':','')) > number(translate(cbc:StartTime,':','')) or number(translate(cbc:EndTime,':','')) = number(translate(cbc:StartTime,':','')))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB081] EndTime must be greater or equal to StartTime</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M31" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:PaymentAlternativeExchangeRate/cac:ForeignExchangeContract/cac:ValidityPeriod/cbc:Description" mode="M31" priority="1001">
    <svrl:fired-rule context="doc:Reminder/cac:PaymentAlternativeExchangeRate/cac:ForeignExchangeContract/cac:ValidityPeriod/cbc:Description" />

		<!--REPORT -->
<xsl:if test="count(../cbc:Description) > 1 and not(./@languageID)">
      <svrl:successful-report test="count(../cbc:Description) > 1 and not(./@languageID)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[W-LIB222] The attribute languageID should be used when more than one Description element is present</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID">
      <svrl:successful-report test="local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[W-LIB223] Multilanguage error. Replicated Description elements with same languageID attribute value</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M31" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:PaymentAlternativeExchangeRate/cac:ForeignExchangeContract/cac:ContractDocumentReference" mode="M31" priority="1000">
    <svrl:fired-rule context="doc:Reminder/cac:PaymentAlternativeExchangeRate/cac:ForeignExchangeContract/cac:ContractDocumentReference" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:DocumentType) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:DocumentType) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB170] DocumentType element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:DocumentTypeCode) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:DocumentTypeCode) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB172] DocumentTypeCode element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="cac:Attachment and cbc:XPath">
      <svrl:successful-report test="cac:Attachment and cbc:XPath">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB169] Use either Attachment or XPath</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Attachment/cbc:EmbeddedDocumentBinaryObject and cac:Attachment/cac:ExternalReference">
      <svrl:successful-report test="cac:Attachment/cbc:EmbeddedDocumentBinaryObject and cac:Attachment/cac:ExternalReference">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB171] Use either EmbeddedDocumentBinaryObject or ExternalReference</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:UUID and not(string-length(string(cbc:UUID)) = 36)">
      <svrl:successful-report test="cbc:UUID and not(string-length(string(cbc:UUID)) = 36)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB173] Invalid UUID. Must be of this form '6E09886B-DC6E-439F-82D1-7CCAC7F4E3B1'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Attachment/cbc:EmbeddedDocumentBinaryObject and not(cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/tiff' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/png' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/jpeg' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/gif' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/pdf' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='text/xml' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='text/csv' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.ms-excel' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.oasis.opendocument.spreadsheet')">
      <svrl:successful-report test="cac:Attachment/cbc:EmbeddedDocumentBinaryObject and not(cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/tiff' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/png' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/jpeg' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/gif' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/pdf' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='text/xml' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='text/csv' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.ms-excel' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.oasis.opendocument.spreadsheet')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB174] Attribute mimeCode must be a value from the codelist</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Attachment/cac:ExternalReference and not(cac:Attachment/cac:ExternalReference/cbc:URI != '')">
      <svrl:successful-report test="cac:Attachment/cac:ExternalReference and not(cac:Attachment/cac:ExternalReference/cbc:URI != '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB096] When using ExternalReference, URI is mandatory</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M31" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M31" priority="-1" />
  <xsl:template match="@*|node()" mode="M31" priority="-2">
    <xsl:apply-templates mode="M31" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN taxtotal-->


	<!--RULE -->
<xsl:template match="doc:Reminder/cac:TaxTotal" mode="M32" priority="1003">
    <svrl:fired-rule context="doc:Reminder/cac:TaxTotal" />

		<!--REPORT -->
<xsl:if test="cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = ./following-sibling::*/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID">
      <svrl:successful-report test="cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = ./following-sibling::*/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB314] Using the same TaxScheme ID in two different TaxTotal classes are not allowed.</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(../cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '63' or cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(../cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '63' or cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']) = 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB306] Exactly one TaxTotal class must contain VAT (Moms)</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="string-length(substring-after(cbc:TaxAmount, '.')) != 2">
      <svrl:successful-report test="string-length(substring-after(cbc:TaxAmount, '.')) != 2">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB250] Invalid TaxAmount. Must have 2 decimals</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:RoundingAmount and (cbc:RoundingAmount = 0)">
      <svrl:successful-report test="cbc:RoundingAmount and (cbc:RoundingAmount = 0)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB251] Invalid RoundingAmount. Must not be zero</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:RoundingAmount and string-length(substring-after(cbc:RoundingAmount, '.')) != 2">
      <svrl:successful-report test="cbc:RoundingAmount and string-length(substring-after(cbc:RoundingAmount, '.')) != 2">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB252] Invalid RoundingAmount. Must have 2 decimals</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:TaxEvidenceIndicator = 'false' and /doc:Invoice/cbc:InvoiceTypeCode != '325'">
      <svrl:successful-report test="cbc:TaxEvidenceIndicator = 'false' and /doc:Invoice/cbc:InvoiceTypeCode != '325'">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB253] Can only be false if proforma invoice (InvoiceTypeCode = '325')</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M32" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:TaxTotal/cac:TaxSubtotal" mode="M32" priority="1002">
    <svrl:fired-rule context="doc:Reminder/cac:TaxTotal/cac:TaxSubtotal" />
    <xsl:variable name="ID63" select="cac:TaxCategory/cac:TaxScheme/cbc:ID = '63'" />
    <xsl:variable name="TaxCategoryID" select="cac:TaxCategory/cbc:ID = 'StandardRated'" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:Percent) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:Percent) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB254] Percent element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:BaseUnitMeasure) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:BaseUnitMeasure) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB255] BaseUnitMeasure element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:PerUnitAmount) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:PerUnitAmount) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB256] PerUnitAmount element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:TierRange) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:TierRange) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB257] TierRange element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:TierRatePercent) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:TierRatePercent) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB258] TierRatePercent element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:TaxableAmount) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:TaxableAmount) != ''">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB259] Invalid TaxableAmount. Must contain a value</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="$ID63 and cac:TaxCategory/cac:TaxScheme/cbc:ID = ./following-sibling::*/cac:TaxCategory/cac:TaxScheme/cbc:ID and cac:TaxCategory/cbc:ID = ./following-sibling::*/cac:TaxCategory/cbc:ID">
      <svrl:successful-report test="$ID63 and cac:TaxCategory/cac:TaxScheme/cbc:ID = ./following-sibling::*/cac:TaxCategory/cac:TaxScheme/cbc:ID and cac:TaxCategory/cbc:ID = ./following-sibling::*/cac:TaxCategory/cbc:ID">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB315] Specifying the same TaxSubtotal.TaxCategory.ID in one TaxTotal class is not allowed</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:TaxCategory/cac:TaxScheme/cbc:ID != ./following-sibling::*/cac:TaxCategory/cac:TaxScheme/cbc:ID">
      <svrl:successful-report test="cac:TaxCategory/cac:TaxScheme/cbc:ID != ./following-sibling::*/cac:TaxCategory/cac:TaxScheme/cbc:ID">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB316] Specifying different TaxScheme.ID in same TaxTotal class is not allowed.</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="string-length(substring-after(cbc:TaxableAmount, '.')) != 2">
      <svrl:successful-report test="string-length(substring-after(cbc:TaxableAmount, '.')) != 2">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB261] Invalid TaxableAmount. Must have 2 decimals</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="string-length(substring-after(cbc:TaxAmount, '.')) != 2">
      <svrl:successful-report test="string-length(substring-after(cbc:TaxAmount, '.')) != 2">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB263] Invalid TaxAmount. Must have 2 decimals</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:CalculationSequenceNumeric and (starts-with(cbc:CalculationSequenceNumeric,'-') or cbc:CalculationSequenceNumeric = 0)">
      <svrl:successful-report test="cbc:CalculationSequenceNumeric and (starts-with(cbc:CalculationSequenceNumeric,'-') or cbc:CalculationSequenceNumeric = 0)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB264] Invalid CalculationSequenceNumeric. Must not be negative or zero</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:TransactionCurrencyTaxAmount and (number(cbc:TransactionCurrencyTaxAmount) != 0) and (cac:TaxCategory/cbc:ID = 'StandardRated') and ( ((number(cbc:TransactionCurrencyTaxAmount) &lt; 0) and (number(../cbc:TaxAmount) > 0)) or ((number(cbc:TransactionCurrencyTaxAmount) > 0)  and (number(../cbc:TaxAmount) &lt; 0)) )">
      <svrl:successful-report test="cbc:TransactionCurrencyTaxAmount and (number(cbc:TransactionCurrencyTaxAmount) != 0) and (cac:TaxCategory/cbc:ID = 'StandardRated') and ( ((number(cbc:TransactionCurrencyTaxAmount) &lt; 0) and (number(../cbc:TaxAmount) > 0)) or ((number(cbc:TransactionCurrencyTaxAmount) > 0) and (number(../cbc:TaxAmount) &lt; 0)) )">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB266] Invalid TransactionCurrencyTaxAmount. Must be negative if TaxTotal/TaxAmount is negative, and must be be positive if TaxTotal/TaxAmount is positive</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:TransactionCurrencyTaxAmount and string-length(substring-after(cbc:TransactionCurrencyTaxAmount, '.')) != 2">
      <svrl:successful-report test="cbc:TransactionCurrencyTaxAmount and string-length(substring-after(cbc:TransactionCurrencyTaxAmount, '.')) != 2">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB267] Invalid TransactionCurrencyTaxAmount. Must have 2 decimals</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:variable name="CalculatedVat" select="(cbc:TaxableAmount div 100) * cac:TaxCategory/cbc:Percent" />

		<!--REPORT -->
<xsl:if test="cac:TaxCategory/cbc:ID = 'StandardRated' and cbc:TaxableAmount > 0 and cbc:TaxAmount = 0 and $CalculatedVat >= 0.005">
      <svrl:successful-report test="cac:TaxCategory/cbc:ID = 'StandardRated' and cbc:TaxableAmount > 0 and cbc:TaxAmount = 0 and $CalculatedVat >= 0.005">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB381] Invalid VAT TaxAmount - When TaxCategory/ID are 'StandardRated' and TaxableAmount &gt; 0 (<xsl:text />
          <xsl:value-of select="cbc:TaxableAmount" />
          <xsl:text />) TaxAmount can't be '(<xsl:text />
          <xsl:value-of select="cbc:TaxAmount" />
          <xsl:text />)' unless calculated vat '(<xsl:text />
          <xsl:value-of select="$CalculatedVat" />
          <xsl:text />)' are less then 0.005</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:TransactionCurrencyTaxAmount and not(cac:TaxCategory/cbc:ID = 'StandardRated')">
      <svrl:successful-report test="cbc:TransactionCurrencyTaxAmount and not(cac:TaxCategory/cbc:ID = 'StandardRated')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB373] TransactionCurrencyTaxAmount only valid when TaxCategory/ID = 'StandardRated'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT') and not(cac:TaxCategory/cbc:Percent)">
      <svrl:successful-report test="(cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT') and not(cac:TaxCategory/cbc:Percent)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB333] When TaxCategory/TaxScheme/Id is VAT, the TaxCategory/Percent must be present.</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT') and ((cac:TaxCategory/cbc:Percent = '') or (string-length(substring-after(cac:TaxCategory/cbc:Percent, '.')) > 2))">
      <svrl:successful-report test="(cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT') and ((cac:TaxCategory/cbc:Percent = '') or (string-length(substring-after(cac:TaxCategory/cbc:Percent, '.')) > 2))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB334] The TaxCategory/Percent must contain a decimal value with maximum 2 decimals.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M32" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory" mode="M32" priority="1001">
    <svrl:fired-rule context="doc:Reminder/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:TierRange) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:TierRange) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB072] TierRange element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:TierRatePercent) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:TierRatePercent) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB073] TierRatePercent element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:ID) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:ID) != ''">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB074] Invalid TaxCategory/ID. Must contain a value.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID/@schemeID = $TaxCategory1_schemeID or cbc:ID/@schemeID = $TaxCategory2_schemeID or cbc:ID/@schemeID = $TaxCategory3_schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID/@schemeID = $TaxCategory1_schemeID or cbc:ID/@schemeID = $TaxCategory2_schemeID or cbc:ID/@schemeID = $TaxCategory3_schemeID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB075] Invalid schemeID. Must be either '<xsl:text />
            <xsl:value-of select="$TaxCategory1_schemeID" />
            <xsl:text />', '<xsl:text />
            <xsl:value-of select="$TaxCategory2_schemeID" />
            <xsl:text />' or '<xsl:text />
            <xsl:value-of select="$TaxCategory3_schemeID" />
            <xsl:text />'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID/@schemeAgencyID = $TaxCategory2_agencyID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID/@schemeAgencyID = $TaxCategory2_agencyID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[W-LIB229] Invalid schemeAgencyID. Must be '320'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="((cbc:ID/@schemeID = $TaxCategory1_schemeID) and not (contains($TaxCategory1, concat(',',cbc:ID,',')))) or ((cbc:ID/@schemeID = $TaxCategory2_schemeID) and not (contains($TaxCategory2, concat(',',cbc:ID,',')))) or ((cbc:ID/@schemeID = $TaxCategory3_schemeID) and not (contains($TaxCategory3, concat(',',cbc:ID,','))))">
      <svrl:successful-report test="((cbc:ID/@schemeID = $TaxCategory1_schemeID) and not (contains($TaxCategory1, concat(',',cbc:ID,',')))) or ((cbc:ID/@schemeID = $TaxCategory2_schemeID) and not (contains($TaxCategory2, concat(',',cbc:ID,',')))) or ((cbc:ID/@schemeID = $TaxCategory3_schemeID) and not (contains($TaxCategory3, concat(',',cbc:ID,','))))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB309] Invalid ID: '<xsl:text />
          <xsl:value-of select="cbc:ID" />
          <xsl:text />'. Must be a value from the codelist</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:Name != '') and not(contains(/doc:Invoice/cbc:ProfileID, 'nesubl.eu'))">
      <svrl:successful-report test="(cbc:Name != '') and not(contains(/doc:Invoice/cbc:ProfileID, 'nesubl.eu'))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[W-LIB230] Name should only be used within NES profiles</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:PerUnitAmount and cbc:Percent">
      <svrl:successful-report test="cbc:PerUnitAmount and cbc:Percent">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB231] Use either PerUnitAmount or Percent</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:PerUnitAmount and not(cbc:BaseUnitMeasure != '')">
      <svrl:successful-report test="cbc:PerUnitAmount and not(cbc:BaseUnitMeasure != '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB232] When PerUnitAmount is used, BaseUnitMeasure is mandatory</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M32" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme" mode="M32" priority="1000">
    <svrl:fired-rule context="doc:Reminder/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:ID) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:ID) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB041] ID element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:AddressTypeCode) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:AddressTypeCode) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB042] AddressTypeCode element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:Postbox) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:Postbox) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB043] Postbox element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:Floor) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:Floor) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB044] Floor element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:Room) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:Room) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB045] Room element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:StreetName) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:StreetName) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB046] StreetName element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:AdditionalStreetName) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:AdditionalStreetName) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB047] AdditionalStreetName element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:BlockName) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:BlockName) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB048] BlockName element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:BuildingName) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:BuildingName) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB049] BuildingName element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:BuildingNumber) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:BuildingNumber) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB050] BuildingNumber element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:InhouseMail) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:InhouseMail) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB051] InhouseMail element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:Department) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:Department) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB052] Department element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:MarkAttention) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:MarkAttention) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB053] MarkAttention element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:MarkCare) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:MarkCare) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB054] MarkCare element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:PlotIdentification) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:PlotIdentification) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB055] PlotIdentification element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:CitySubdivisionName) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:CitySubdivisionName) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB056] CitySubdivisionName element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:CityName) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:CityName) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB057] CityName element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:PostalZone) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:PostalZone) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB058] PostalZone element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:CountrySubentity) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:CountrySubentity) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB059] CountrySubentity element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:CountrySubentityCode) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:CountrySubentityCode) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB060] CountrySubentityCode element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:TimezoneOffset) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:TimezoneOffset) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB063] TimezoneOffset element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cac:AddressLine) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cac:AddressLine) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB234] AddressLine class must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cac:LocationCoordinate) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cac:LocationCoordinate) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB064] LocationCoordinate class must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:ID = '63') and cbc:TaxTypeCode">
      <svrl:successful-report test="(cbc:ID = '63') and cbc:TaxTypeCode">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB067] TaxTypeCode is not allowed when TaxScheme/ID equals '63' (Moms)</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:ID) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:ID) != ''">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB065] Invalid TaxScheme/ID. Must contain a value.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:Name) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:Name) != ''">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB066] Invalid Name. Must contain a value</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="not((cbc:ID = '63' or cbc:ID = 'VAT')) and not(contains($TaxType2, concat(',',cbc:TaxTypeCode,',')))">
      <svrl:successful-report test="not((cbc:ID = '63' or cbc:ID = 'VAT')) and not(contains($TaxType2, concat(',',cbc:TaxTypeCode,',')))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB197] TaxTypeCode must be a value from the '<xsl:text />
          <xsl:value-of select="$TaxType_listID2" />
          <xsl:text />' codelist when TaxScheme/ID is different from '63' or 'VAT' (Moms)</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID/@schemeID = $TaxScheme_schemeID or cbc:ID/@schemeID = $TaxScheme2_schemeID or cbc:ID/@schemeID = $TaxScheme4_schemeID or cbc:ID/@schemeID = $TaxScheme5_schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID/@schemeID = $TaxScheme_schemeID or cbc:ID/@schemeID = $TaxScheme2_schemeID or cbc:ID/@schemeID = $TaxScheme4_schemeID or cbc:ID/@schemeID = $TaxScheme5_schemeID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB070] Invalid schemeID. Must be either '<xsl:text />
            <xsl:value-of select="$TaxScheme_schemeID" />
            <xsl:text />', '<xsl:text />
            <xsl:value-of select="$TaxScheme2_schemeID" />
            <xsl:text />', '<xsl:text />
            <xsl:value-of select="$TaxScheme4_schemeID" />
            <xsl:text />' or '<xsl:text />
            <xsl:value-of select="$TaxScheme5_schemeID" />
            <xsl:text />'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:TaxTypeCode) and not((cbc:TaxTypeCode/@listID = $TaxType_listID) or (cbc:TaxTypeCode/@listID = $TaxType_listID2))">
      <svrl:successful-report test="(cbc:TaxTypeCode) and not((cbc:TaxTypeCode/@listID = $TaxType_listID) or (cbc:TaxTypeCode/@listID = $TaxType_listID2))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB071] Invalid listID. Must be either '<xsl:text />
          <xsl:value-of select="$TaxType_listID" />
          <xsl:text />' or '<xsl:text />
          <xsl:value-of select="$TaxType_listID2" />
          <xsl:text />'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID = '63') and cbc:Name != 'Moms'">
      <svrl:successful-report test="(cbc:ID = '63') and cbc:Name != 'Moms'">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB198] Name must equal 'Moms' when TaxScheme/ID equals '63' (Moms)</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID != '63') and cbc:Name = 'Moms'">
      <svrl:successful-report test="(cbc:ID != '63') and cbc:Name = 'Moms'">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB199] Name must correspond to the value of TaxScheme/ID</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cac:JurisdictionRegionAddress/cac:Country/cbc:IdentificationCode) and not(contains($CountryCode, concat(',',cac:JurisdictionRegionAddress/cac:Country/cbc:IdentificationCode,',')))">
      <svrl:successful-report test="(cac:JurisdictionRegionAddress/cac:Country/cbc:IdentificationCode) and not(contains($CountryCode, concat(',',cac:JurisdictionRegionAddress/cac:Country/cbc:IdentificationCode,',')))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB337] Invalid Country/IdentificationCode: '<xsl:text />
          <xsl:value-of select="cac:JurisdictionRegionAddress/cac:Country/cbc:IdentificationCode" />
          <xsl:text />'. Must be a value from the country codelist</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cac:JurisdictionRegionAddress) and cac:JurisdictionRegionAddress/cbc:AddressFormatCode != 'StructuredRegion'">
      <svrl:successful-report test="(cac:JurisdictionRegionAddress) and cac:JurisdictionRegionAddress/cbc:AddressFormatCode != 'StructuredRegion'">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB233] The AddressFormatCode under JurisdictionRegionAddress must always equal 'StructuredRegion'</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M32" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M32" priority="-1" />
  <xsl:template match="@*|node()" mode="M32" priority="-2">
    <xsl:apply-templates mode="M32" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN legalmonetarytotal-->


	<!--RULE -->
<xsl:template match="doc:Reminder/cac:LegalMonetaryTotal" mode="M33" priority="1008">
    <svrl:fired-rule context="doc:Reminder/cac:LegalMonetaryTotal" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:LineExtensionAmount) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:LineExtensionAmount) != ''">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-REM054] Invalid LineExtensionAmount. Must contain a value</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="count(../cac:AllowanceCharge[cbc:ChargeIndicator='false']) and not(cbc:AllowanceTotalAmount)">
      <svrl:successful-report test="count(../cac:AllowanceCharge[cbc:ChargeIndicator='false']) and not(cbc:AllowanceTotalAmount)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-REM074] AllowanceTotalAmount is mandatory when AllowanceCharge classes (with ChargeIndicator='false') are present</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="count(../cac:AllowanceCharge[cbc:ChargeIndicator='true']) and not(cbc:ChargeTotalAmount)">
      <svrl:successful-report test="count(../cac:AllowanceCharge[cbc:ChargeIndicator='true']) and not(cbc:ChargeTotalAmount)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-REM075] ChargeTotalAmount is mandatory when AllowanceCharge classes (with ChargeIndicator='true') are present</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="count(../cac:PrepaidPayment/cbc:PaidAmount) and not(cbc:PrepaidAmount)">
      <svrl:successful-report test="count(../cac:PrepaidPayment/cbc:PaidAmount) and not(cbc:PrepaidAmount)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-REM076] PrepaidAmount is mandatory when PrepaidPayment/PaidAmount elements are present</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="count(../cac:TaxTotal/cbc:RoundingAmount) and not(cbc:PayableRoundingAmount)">
      <svrl:successful-report test="count(../cac:TaxTotal/cbc:RoundingAmount) and not(cbc:PayableRoundingAmount)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-REM077] PayableRoundingAmount is mandatory when TaxTotal/RoundingAmount elements are present</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:TaxExclusiveAmount and not(format-number(cbc:TaxExclusiveAmount,'##.00') = format-number(sum(../cac:TaxTotal/cac:TaxSubtotal/cbc:TaxAmount),'##.00'))">
      <svrl:successful-report test="cbc:TaxExclusiveAmount and not(format-number(cbc:TaxExclusiveAmount,'##.00') = format-number(sum(../cac:TaxTotal/cac:TaxSubtotal/cbc:TaxAmount),'##.00'))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-REM079] The sum of TaxTotal/TaxSubtotal/TaxAmount elements must equal TaxExclusiveAmount</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:TaxInclusiveAmount and not(format-number(cbc:TaxInclusiveAmount,'##.00') = format-number(sum(cbc:LineExtensionAmount) + sum(../cac:TaxTotal/cac:TaxSubtotal/cbc:TaxAmount) + sum(cbc:ChargeTotalAmount) - sum(cbc:AllowanceTotalAmount) + sum(cbc:PayableRoundingAmount),'##.00'))">
      <svrl:successful-report test="cbc:TaxInclusiveAmount and not(format-number(cbc:TaxInclusiveAmount,'##.00') = format-number(sum(cbc:LineExtensionAmount) + sum(../cac:TaxTotal/cac:TaxSubtotal/cbc:TaxAmount) + sum(cbc:ChargeTotalAmount) - sum(cbc:AllowanceTotalAmount) + sum(cbc:PayableRoundingAmount),'##.00'))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-REM080] TaxInclusiveAmount is calculated incorrectly</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AllowanceTotalAmount and not(format-number(cbc:AllowanceTotalAmount,'##.00') = format-number(sum(../cac:AllowanceCharge[cbc:ChargeIndicator='false']/cbc:Amount),'##.00'))">
      <svrl:successful-report test="cbc:AllowanceTotalAmount and not(format-number(cbc:AllowanceTotalAmount,'##.00') = format-number(sum(../cac:AllowanceCharge[cbc:ChargeIndicator='false']/cbc:Amount),'##.00'))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-REM081] The sum of AllowanceCharge/Amount elements (with ChargeIndicator='false') must equal AllowanceTotalAmount</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:ChargeTotalAmount and not(format-number(cbc:ChargeTotalAmount,'##.00') = format-number(sum(../cac:AllowanceCharge[cbc:ChargeIndicator='true']/cbc:Amount),'##.00'))">
      <svrl:successful-report test="cbc:ChargeTotalAmount and not(format-number(cbc:ChargeTotalAmount,'##.00') = format-number(sum(../cac:AllowanceCharge[cbc:ChargeIndicator='true']/cbc:Amount),'##.00'))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-REM082] The sum of AllowanceCharge/Amount elements (with ChargeIndicator='true') must equal cbc:ChargeTotalAmount</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:PrepaidAmount and not(format-number(cbc:PrepaidAmount,'##.00') = format-number(sum(../cac:PrepaidPayment/cbc:PaidAmount),'##.00'))">
      <svrl:successful-report test="cbc:PrepaidAmount and not(format-number(cbc:PrepaidAmount,'##.00') = format-number(sum(../cac:PrepaidPayment/cbc:PaidAmount),'##.00'))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-REM083] The sum of PrepaidPayment/PaidAmount elements must equal PrepaidAmount</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:PayableRoundingAmount and not(format-number(cbc:PayableRoundingAmount,'##.00') = format-number(sum(../cac:TaxTotal/cbc:RoundingAmount),'##.00'))">
      <svrl:successful-report test="cbc:PayableRoundingAmount and not(format-number(cbc:PayableRoundingAmount,'##.00') = format-number(sum(../cac:TaxTotal/cbc:RoundingAmount),'##.00'))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-REM084] The sum of TaxTotal/RoundingAmount elements must equal PayableRoundingAmount</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="format-number(sum(cbc:PayableAmount) *-1,'##.00') = format-number((sum(cbc:LineExtensionAmount) + sum(../cac:TaxTotal/cac:TaxSubtotal/cbc:TaxAmount) + sum(cbc:ChargeTotalAmount) - sum(cbc:AllowanceTotalAmount) - sum(cbc:PrepaidAmount) + sum(cbc:PayableRoundingAmount)) *-1,'##.00')" />
      <xsl:otherwise>
        <svrl:failed-assert test="format-number(sum(cbc:PayableAmount) *-1,'##.00') = format-number((sum(cbc:LineExtensionAmount) + sum(../cac:TaxTotal/cac:TaxSubtotal/cbc:TaxAmount) + sum(cbc:ChargeTotalAmount) - sum(cbc:AllowanceTotalAmount) - sum(cbc:PrepaidAmount) + sum(cbc:PayableRoundingAmount)) *-1,'##.00')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-REM085] PayableAmount is calculated incorrectly</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="(count(../cac:PaymentTerms) > 0) and not (  (format-number(cbc:PayableAmount,'##.00') = format-number(sum(../cac:PaymentTerms/cbc:Amount),'##.00'))   or   (format-number(cbc:PayableAmount,'##.00') = format-number(../cac:PaymentTerms[1]/cbc:Amount,'##.00')))">
      <svrl:successful-report test="(count(../cac:PaymentTerms) > 0) and not ( (format-number(cbc:PayableAmount,'##.00') = format-number(sum(../cac:PaymentTerms/cbc:Amount),'##.00')) or (format-number(cbc:PayableAmount,'##.00') = format-number(../cac:PaymentTerms[1]/cbc:Amount,'##.00')))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-REM086] The sum of PaymentTerms/Amount elements or the value of the first PaymentTerms/Amount must equal PayableAmount</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M33" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:LegalMonetaryTotal/cbc:LineExtensionAmount" mode="M33" priority="1007">
    <svrl:fired-rule context="doc:Reminder/cac:LegalMonetaryTotal/cbc:LineExtensionAmount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test=". != 0" />
      <xsl:otherwise>
        <svrl:failed-assert test=". != 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB303] Invalid <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />. Must not be zero</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="string-length(substring-after(., '.')) != 2">
      <svrl:successful-report test="string-length(substring-after(., '.')) != 2">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB014] Invalid <xsl:text />
          <xsl:value-of select="name(.)" />
          <xsl:text />. Must have 2 decimals</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M33" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:LegalMonetaryTotal/cbc:TaxExclusiveAmount" mode="M33" priority="1006">
    <svrl:fired-rule context="doc:Reminder/cac:LegalMonetaryTotal/cbc:TaxExclusiveAmount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(starts-with(.,'-'))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(starts-with(.,'-'))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB016] Invalid <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />. Must not be negative</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="string-length(substring-after(., '.')) != 2">
      <svrl:successful-report test="string-length(substring-after(., '.')) != 2">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB014] Invalid <xsl:text />
          <xsl:value-of select="name(.)" />
          <xsl:text />. Must have 2 decimals</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M33" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:LegalMonetaryTotal/cbc:TaxInclusiveAmount" mode="M33" priority="1005">
    <svrl:fired-rule context="doc:Reminder/cac:LegalMonetaryTotal/cbc:TaxInclusiveAmount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(starts-with(.,'-')) and . != 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(starts-with(.,'-')) and . != 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB013] Invalid <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />. Must not be negative or zero</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="string-length(substring-after(., '.')) != 2">
      <svrl:successful-report test="string-length(substring-after(., '.')) != 2">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB014] Invalid <xsl:text />
          <xsl:value-of select="name(.)" />
          <xsl:text />. Must have 2 decimals</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M33" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:LegalMonetaryTotal/cbc:AllowanceTotalAmount" mode="M33" priority="1004">
    <svrl:fired-rule context="doc:Reminder/cac:LegalMonetaryTotal/cbc:AllowanceTotalAmount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(starts-with(.,'-')) and . != 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(starts-with(.,'-')) and . != 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB013] Invalid <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />. Must not be negative or zero</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="string-length(substring-after(., '.')) != 2">
      <svrl:successful-report test="string-length(substring-after(., '.')) != 2">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB014] Invalid <xsl:text />
          <xsl:value-of select="name(.)" />
          <xsl:text />. Must have 2 decimals</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M33" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:LegalMonetaryTotal/cbc:ChargeTotalAmount" mode="M33" priority="1003">
    <svrl:fired-rule context="doc:Reminder/cac:LegalMonetaryTotal/cbc:ChargeTotalAmount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(starts-with(.,'-')) and . != 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(starts-with(.,'-')) and . != 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB013] Invalid <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />. Must not be negative or zero</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="string-length(substring-after(., '.')) != 2">
      <svrl:successful-report test="string-length(substring-after(., '.')) != 2">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB014] Invalid <xsl:text />
          <xsl:value-of select="name(.)" />
          <xsl:text />. Must have 2 decimals</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M33" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:LegalMonetaryTotal/cbc:PrepaidAmount" mode="M33" priority="1002">
    <svrl:fired-rule context="doc:Reminder/cac:LegalMonetaryTotal/cbc:PrepaidAmount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(starts-with(.,'-')) and . != 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(starts-with(.,'-')) and . != 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB013] Invalid <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />. Must not be negative or zero</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="string-length(substring-after(., '.')) != 2">
      <svrl:successful-report test="string-length(substring-after(., '.')) != 2">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB014] Invalid <xsl:text />
          <xsl:value-of select="name(.)" />
          <xsl:text />. Must have 2 decimals</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M33" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:LegalMonetaryTotal/cbc:PayableRoundingAmount" mode="M33" priority="1001">
    <svrl:fired-rule context="doc:Reminder/cac:LegalMonetaryTotal/cbc:PayableRoundingAmount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test=". != 0" />
      <xsl:otherwise>
        <svrl:failed-assert test=". != 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB303] Invalid <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />. Must not be zero</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="string-length(substring-after(., '.')) != 2">
      <svrl:successful-report test="string-length(substring-after(., '.')) != 2">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB014] Invalid <xsl:text />
          <xsl:value-of select="name(.)" />
          <xsl:text />. Must have 2 decimals</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M33" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:LegalMonetaryTotal/cbc:PayableAmount" mode="M33" priority="1000">
    <svrl:fired-rule context="doc:Reminder/cac:LegalMonetaryTotal/cbc:PayableAmount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(starts-with(.,'-')) and . != 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(starts-with(.,'-')) and . != 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB013] Invalid <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />. Must not be negative or zero</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="string-length(substring-after(., '.')) != 2">
      <svrl:successful-report test="string-length(substring-after(., '.')) != 2">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB014] Invalid <xsl:text />
          <xsl:value-of select="name(.)" />
          <xsl:text />. Must have 2 decimals</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M33" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M33" priority="-1" />
  <xsl:template match="@*|node()" mode="M33" priority="-2">
    <xsl:apply-templates mode="M33" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN reminderline-->


	<!--RULE -->
<xsl:template match="doc:Reminder/cac:ReminderLine" mode="M34" priority="1022">
    <svrl:fired-rule context="doc:Reminder/cac:ReminderLine" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:ID) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:ID) != ''">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-REM058] Invalid ID. Must contain a value</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="cbc:AccountingCost and cbc:AccountingCostCode">
      <svrl:successful-report test="cbc:AccountingCost and cbc:AccountingCostCode">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB021] Use either AccountingCost or AccountingCostCode</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="count(cac:ReminderPeriod) > 1">
      <svrl:successful-report test="count(cac:ReminderPeriod) > 1">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-REM087] No more than one ReminderPeriod class may be present</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="count(cac:BillingReference) > 1">
      <svrl:successful-report test="count(cac:BillingReference) > 1">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-REM088] No more than one BillingReference class may be present</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M34" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:ReminderLine/cbc:UUID" mode="M34" priority="1021">
    <svrl:fired-rule context="doc:Reminder/cac:ReminderLine/cbc:UUID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(string(.)) = 36" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(string(.)) = 36">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB006] Invalid <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />. Must be of this form '6E09886B-DC6E-439F-82D1-7CCAC7F4E3B1'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M34" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:ReminderLine/cbc:DebitLineAmount" mode="M34" priority="1020">
    <svrl:fired-rule context="doc:Reminder/cac:ReminderLine/cbc:DebitLineAmount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(starts-with(.,'-')) and . != 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(starts-with(.,'-')) and . != 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB013] Invalid <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />. Must not be negative or zero</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="string-length(substring-after(., '.')) != 2">
      <svrl:successful-report test="string-length(substring-after(., '.')) != 2">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB014] Invalid <xsl:text />
          <xsl:value-of select="name(.)" />
          <xsl:text />. Must have 2 decimals</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M34" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:ReminderLine/cbc:CreditLineAmount" mode="M34" priority="1019">
    <svrl:fired-rule context="doc:Reminder/cac:ReminderLine/cbc:CreditLineAmount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(starts-with(.,'-')) and . != 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(starts-with(.,'-')) and . != 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB013] Invalid <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />. Must not be negative or zero</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="string-length(substring-after(., '.')) != 2">
      <svrl:successful-report test="string-length(substring-after(., '.')) != 2">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB014] Invalid <xsl:text />
          <xsl:value-of select="name(.)" />
          <xsl:text />. Must have 2 decimals</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M34" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:ReminderLine/cac:ReminderPeriod" mode="M34" priority="1018">
    <svrl:fired-rule context="doc:Reminder/cac:ReminderLine/cac:ReminderPeriod" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:DurationMeasure) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:DurationMeasure) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB076] DurationMeasure element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:DescriptionCode) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:DescriptionCode) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB077] DescriptionCode element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:StartTime) and (not(cbc:StartDate) or cbc:StartDate = '')">
      <svrl:successful-report test="(cbc:StartTime) and (not(cbc:StartDate) or cbc:StartDate = '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB078] There must be a StartDate if you have a StartTime</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:EndTime) and (not(cbc:EndDate) or cbc:EndDate = '')">
      <svrl:successful-report test="(cbc:EndTime) and (not(cbc:EndDate) or cbc:EndDate = '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB079] There must be a EndDate if you have a EndTime</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:StartDate and cbc:EndDate) and not(number(translate(cbc:EndDate,'-','')) > number(translate(cbc:StartDate,'-','')) or number(translate(cbc:EndDate,'-','')) = number(translate(cbc:StartDate,'-','')))">
      <svrl:successful-report test="(cbc:StartDate and cbc:EndDate) and not(number(translate(cbc:EndDate,'-','')) > number(translate(cbc:StartDate,'-','')) or number(translate(cbc:EndDate,'-','')) = number(translate(cbc:StartDate,'-','')))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB080] The EndDate must be greater or equal to the startdate</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:StartTime and cbc:EndTime) and not(number(translate(cbc:EndTime,':','')) > number(translate(cbc:StartTime,':','')) or number(translate(cbc:EndTime,':','')) = number(translate(cbc:StartTime,':','')))">
      <svrl:successful-report test="(cbc:StartTime and cbc:EndTime) and not(number(translate(cbc:EndTime,':','')) > number(translate(cbc:StartTime,':','')) or number(translate(cbc:EndTime,':','')) = number(translate(cbc:StartTime,':','')))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB081] EndTime must be greater or equal to StartTime</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M34" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:ReminderLine/cac:ReminderPeriod/cbc:Description" mode="M34" priority="1017">
    <svrl:fired-rule context="doc:Reminder/cac:ReminderLine/cac:ReminderPeriod/cbc:Description" />

		<!--REPORT -->
<xsl:if test="count(../cbc:Description) > 1 and not(./@languageID)">
      <svrl:successful-report test="count(../cbc:Description) > 1 and not(./@languageID)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[W-LIB222] The attribute languageID should be used when more than one Description element is present</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID">
      <svrl:successful-report test="local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[W-LIB223] Multilanguage error. Replicated Description elements with same languageID attribute value</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M34" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:ReminderLine/cac:BillingReference" mode="M34" priority="1016">
    <svrl:fired-rule context="doc:Reminder/cac:ReminderLine/cac:BillingReference" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:DebitNoteDocumentReference) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:DebitNoteDocumentReference) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-REM089] DebitNoteDocumentReference class must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:AdditionalDocumentReference) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:AdditionalDocumentReference) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-REM090] AdditionalDocumentReference class must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="count(cac:BillingReferenceLine) > 1">
      <svrl:successful-report test="count(cac:BillingReferenceLine) > 1">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-REM091] No more than one BillingReferenceLine class may be present</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M34" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:ReminderLine/cac:BillingReference/cac:InvoiceDocumentReference" mode="M34" priority="1015">
    <svrl:fired-rule context="doc:Reminder/cac:ReminderLine/cac:BillingReference/cac:InvoiceDocumentReference" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:DocumentType) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:DocumentType) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB170] DocumentType element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:DocumentTypeCode) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:DocumentTypeCode) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB172] DocumentTypeCode element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="cac:Attachment and cbc:XPath">
      <svrl:successful-report test="cac:Attachment and cbc:XPath">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB169] Use either Attachment or XPath</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Attachment/cbc:EmbeddedDocumentBinaryObject and cac:Attachment/cac:ExternalReference">
      <svrl:successful-report test="cac:Attachment/cbc:EmbeddedDocumentBinaryObject and cac:Attachment/cac:ExternalReference">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB171] Use either EmbeddedDocumentBinaryObject or ExternalReference</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:UUID and not(string-length(string(cbc:UUID)) = 36)">
      <svrl:successful-report test="cbc:UUID and not(string-length(string(cbc:UUID)) = 36)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB173] Invalid UUID. Must be of this form '6E09886B-DC6E-439F-82D1-7CCAC7F4E3B1'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Attachment/cbc:EmbeddedDocumentBinaryObject and not(cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/tiff' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/png' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/jpeg' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/gif' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/pdf' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='text/xml' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='text/csv' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.ms-excel' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.oasis.opendocument.spreadsheet')">
      <svrl:successful-report test="cac:Attachment/cbc:EmbeddedDocumentBinaryObject and not(cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/tiff' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/png' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/jpeg' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/gif' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/pdf' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='text/xml' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='text/csv' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.ms-excel' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.oasis.opendocument.spreadsheet')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB174] Attribute mimeCode must be a value from the codelist</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Attachment/cac:ExternalReference and not(cac:Attachment/cac:ExternalReference/cbc:URI != '')">
      <svrl:successful-report test="cac:Attachment/cac:ExternalReference and not(cac:Attachment/cac:ExternalReference/cbc:URI != '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB096] When using ExternalReference, URI is mandatory</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M34" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:ReminderLine/cac:BillingReference/cac:SelfBilledInvoiceDocumentReference" mode="M34" priority="1014">
    <svrl:fired-rule context="doc:Reminder/cac:ReminderLine/cac:BillingReference/cac:SelfBilledInvoiceDocumentReference" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:DocumentType) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:DocumentType) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB170] DocumentType element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:DocumentTypeCode) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:DocumentTypeCode) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB172] DocumentTypeCode element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="cac:Attachment and cbc:XPath">
      <svrl:successful-report test="cac:Attachment and cbc:XPath">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB169] Use either Attachment or XPath</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Attachment/cbc:EmbeddedDocumentBinaryObject and cac:Attachment/cac:ExternalReference">
      <svrl:successful-report test="cac:Attachment/cbc:EmbeddedDocumentBinaryObject and cac:Attachment/cac:ExternalReference">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB171] Use either EmbeddedDocumentBinaryObject or ExternalReference</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:UUID and not(string-length(string(cbc:UUID)) = 36)">
      <svrl:successful-report test="cbc:UUID and not(string-length(string(cbc:UUID)) = 36)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB173] Invalid UUID. Must be of this form '6E09886B-DC6E-439F-82D1-7CCAC7F4E3B1'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Attachment/cbc:EmbeddedDocumentBinaryObject and not(cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/tiff' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/png' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/jpeg' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/gif' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/pdf' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='text/xml' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='text/csv' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.ms-excel' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.oasis.opendocument.spreadsheet')">
      <svrl:successful-report test="cac:Attachment/cbc:EmbeddedDocumentBinaryObject and not(cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/tiff' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/png' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/jpeg' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/gif' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/pdf' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='text/xml' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='text/csv' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.ms-excel' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.oasis.opendocument.spreadsheet')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB174] Attribute mimeCode must be a value from the codelist</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Attachment/cac:ExternalReference and not(cac:Attachment/cac:ExternalReference/cbc:URI != '')">
      <svrl:successful-report test="cac:Attachment/cac:ExternalReference and not(cac:Attachment/cac:ExternalReference/cbc:URI != '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB096] When using ExternalReference, URI is mandatory</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M34" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:ReminderLine/cac:BillingReference/cac:CreditNoteDocumentReference" mode="M34" priority="1013">
    <svrl:fired-rule context="doc:Reminder/cac:ReminderLine/cac:BillingReference/cac:CreditNoteDocumentReference" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:DocumentType) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:DocumentType) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB170] DocumentType element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:DocumentTypeCode) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:DocumentTypeCode) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB172] DocumentTypeCode element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="cac:Attachment and cbc:XPath">
      <svrl:successful-report test="cac:Attachment and cbc:XPath">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB169] Use either Attachment or XPath</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Attachment/cbc:EmbeddedDocumentBinaryObject and cac:Attachment/cac:ExternalReference">
      <svrl:successful-report test="cac:Attachment/cbc:EmbeddedDocumentBinaryObject and cac:Attachment/cac:ExternalReference">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB171] Use either EmbeddedDocumentBinaryObject or ExternalReference</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:UUID and not(string-length(string(cbc:UUID)) = 36)">
      <svrl:successful-report test="cbc:UUID and not(string-length(string(cbc:UUID)) = 36)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB173] Invalid UUID. Must be of this form '6E09886B-DC6E-439F-82D1-7CCAC7F4E3B1'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Attachment/cbc:EmbeddedDocumentBinaryObject and not(cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/tiff' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/png' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/jpeg' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/gif' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/pdf' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='text/xml' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='text/csv' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.ms-excel' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.oasis.opendocument.spreadsheet')">
      <svrl:successful-report test="cac:Attachment/cbc:EmbeddedDocumentBinaryObject and not(cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/tiff' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/png' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/jpeg' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/gif' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/pdf' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='text/xml' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='text/csv' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.ms-excel' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.oasis.opendocument.spreadsheet')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB174] Attribute mimeCode must be a value from the codelist</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Attachment/cac:ExternalReference and not(cac:Attachment/cac:ExternalReference/cbc:URI != '')">
      <svrl:successful-report test="cac:Attachment/cac:ExternalReference and not(cac:Attachment/cac:ExternalReference/cbc:URI != '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB096] When using ExternalReference, URI is mandatory</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M34" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:ReminderLine/cac:BillingReference/cac:SelfBilledCreditNoteDocumentReference" mode="M34" priority="1012">
    <svrl:fired-rule context="doc:Reminder/cac:ReminderLine/cac:BillingReference/cac:SelfBilledCreditNoteDocumentReference" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:DocumentType) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:DocumentType) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB170] DocumentType element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:DocumentTypeCode) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:DocumentTypeCode) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB172] DocumentTypeCode element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="cac:Attachment and cbc:XPath">
      <svrl:successful-report test="cac:Attachment and cbc:XPath">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB169] Use either Attachment or XPath</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Attachment/cbc:EmbeddedDocumentBinaryObject and cac:Attachment/cac:ExternalReference">
      <svrl:successful-report test="cac:Attachment/cbc:EmbeddedDocumentBinaryObject and cac:Attachment/cac:ExternalReference">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB171] Use either EmbeddedDocumentBinaryObject or ExternalReference</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:UUID and not(string-length(string(cbc:UUID)) = 36)">
      <svrl:successful-report test="cbc:UUID and not(string-length(string(cbc:UUID)) = 36)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB173] Invalid UUID. Must be of this form '6E09886B-DC6E-439F-82D1-7CCAC7F4E3B1'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Attachment/cbc:EmbeddedDocumentBinaryObject and not(cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/tiff' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/png' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/jpeg' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/gif' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/pdf' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='text/xml' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='text/csv' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.ms-excel' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.oasis.opendocument.spreadsheet')">
      <svrl:successful-report test="cac:Attachment/cbc:EmbeddedDocumentBinaryObject and not(cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/tiff' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/png' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/jpeg' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/gif' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/pdf' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='text/xml' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='text/csv' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.ms-excel' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.oasis.opendocument.spreadsheet')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB174] Attribute mimeCode must be a value from the codelist</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Attachment/cac:ExternalReference and not(cac:Attachment/cac:ExternalReference/cbc:URI != '')">
      <svrl:successful-report test="cac:Attachment/cac:ExternalReference and not(cac:Attachment/cac:ExternalReference/cbc:URI != '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB096] When using ExternalReference, URI is mandatory</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M34" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:ReminderLine/cac:BillingReference/cac:ReminderDocumentReference" mode="M34" priority="1011">
    <svrl:fired-rule context="doc:Reminder/cac:ReminderLine/cac:BillingReference/cac:ReminderDocumentReference" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:DocumentType) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:DocumentType) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB170] DocumentType element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:DocumentTypeCode) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:DocumentTypeCode) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB172] DocumentTypeCode element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="cac:Attachment and cbc:XPath">
      <svrl:successful-report test="cac:Attachment and cbc:XPath">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB169] Use either Attachment or XPath</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Attachment/cbc:EmbeddedDocumentBinaryObject and cac:Attachment/cac:ExternalReference">
      <svrl:successful-report test="cac:Attachment/cbc:EmbeddedDocumentBinaryObject and cac:Attachment/cac:ExternalReference">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB171] Use either EmbeddedDocumentBinaryObject or ExternalReference</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:UUID and not(string-length(string(cbc:UUID)) = 36)">
      <svrl:successful-report test="cbc:UUID and not(string-length(string(cbc:UUID)) = 36)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB173] Invalid UUID. Must be of this form '6E09886B-DC6E-439F-82D1-7CCAC7F4E3B1'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Attachment/cbc:EmbeddedDocumentBinaryObject and not(cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/tiff' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/png' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/jpeg' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/gif' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/pdf' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='text/xml' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='text/csv' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.ms-excel' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.oasis.opendocument.spreadsheet')">
      <svrl:successful-report test="cac:Attachment/cbc:EmbeddedDocumentBinaryObject and not(cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/tiff' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/png' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/jpeg' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/gif' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/pdf' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='text/xml' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='text/csv' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.ms-excel' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.oasis.opendocument.spreadsheet')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB174] Attribute mimeCode must be a value from the codelist</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Attachment/cac:ExternalReference and not(cac:Attachment/cac:ExternalReference/cbc:URI != '')">
      <svrl:successful-report test="cac:Attachment/cac:ExternalReference and not(cac:Attachment/cac:ExternalReference/cbc:URI != '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB096] When using ExternalReference, URI is mandatory</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M34" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:ReminderLine/cac:BillingReference/cac:BillingReferenceLine" mode="M34" priority="1010">
    <svrl:fired-rule context="doc:Reminder/cac:ReminderLine/cac:BillingReference/cac:BillingReferenceLine" />

		<!--REPORT -->
<xsl:if test="count(cac:AllowanceCharge) > 1">
      <svrl:successful-report test="count(cac:AllowanceCharge) > 1">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-REM092] No more than one AllowanceCharge class may be present</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M34" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:ReminderLine/cac:BillingReference/cac:BillingReferenceLine/cac:AllowanceCharge" mode="M34" priority="1009">
    <svrl:fired-rule context="doc:Reminder/cac:ReminderLine/cac:BillingReference/cac:BillingReferenceLine/cac:AllowanceCharge" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:TaxTotal) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:TaxTotal) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB224] TaxTotal class must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:PaymentMeans) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:PaymentMeans) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB225] PaymentMeans class must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:TaxCategory) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:TaxCategory) = 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB226] One TaxCategory class must be present</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="cbc:MultiplierFactorNumeric and not(cbc:BaseAmount != '')">
      <svrl:successful-report test="cbc:MultiplierFactorNumeric and not(cbc:BaseAmount != '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB248] When MultiplierFactorNumeric is used, BaseAmount is mandatory</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="starts-with(cbc:MultiplierFactorNumeric,'-')">
      <svrl:successful-report test="starts-with(cbc:MultiplierFactorNumeric,'-')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB227] MultiplierFactorNumeric must be a positive number</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:MultiplierFactorNumeric and ((cbc:Amount - (cbc:BaseAmount * cbc:MultiplierFactorNumeric) &lt; '-1.00') or (cbc:Amount - (cbc:BaseAmount * cbc:MultiplierFactorNumeric) > '1.00'))">
      <svrl:successful-report test="cbc:MultiplierFactorNumeric and ((cbc:Amount - (cbc:BaseAmount * cbc:MultiplierFactorNumeric) &lt; '-1.00') or (cbc:Amount - (cbc:BaseAmount * cbc:MultiplierFactorNumeric) > '1.00'))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB228] Amount must equal BaseAmount * MultiplierFactorNumeric</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AccountingCost and cbc:AccountingCostCode">
      <svrl:successful-report test="cbc:AccountingCost and cbc:AccountingCostCode">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB021] Use either AccountingCost or AccountingCostCode</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M34" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:ReminderLine/cac:BillingReference/cac:BillingReferenceLine/cac:AllowanceCharge/cbc:SequenceNumeric" mode="M34" priority="1008">
    <svrl:fired-rule context="doc:Reminder/cac:ReminderLine/cac:BillingReference/cac:BillingReferenceLine/cac:AllowanceCharge/cbc:SequenceNumeric" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(starts-with(.,'-'))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(starts-with(.,'-'))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB020] Invalid <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />. Must not be negative</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M34" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:ReminderLine/cac:BillingReference/cac:BillingReferenceLine/cac:AllowanceCharge/cbc:Amount" mode="M34" priority="1007">
    <svrl:fired-rule context="doc:Reminder/cac:ReminderLine/cac:BillingReference/cac:BillingReferenceLine/cac:AllowanceCharge/cbc:Amount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(starts-with(.,'-')) and . != 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(starts-with(.,'-')) and . != 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB019] Invalid <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />. Must not be negative or zero</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M34" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:ReminderLine/cac:BillingReference/cac:BillingReferenceLine/cac:AllowanceCharge/cbc:BaseAmount" mode="M34" priority="1006">
    <svrl:fired-rule context="doc:Reminder/cac:ReminderLine/cac:BillingReference/cac:BillingReferenceLine/cac:AllowanceCharge/cbc:BaseAmount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(starts-with(.,'-')) and . != 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(starts-with(.,'-')) and . != 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB019] Invalid <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />. Must not be negative or zero</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M34" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:ReminderLine/cac:BillingReference/cac:BillingReferenceLine/cac:AllowanceCharge/cac:TaxCategory" mode="M34" priority="1005">
    <svrl:fired-rule context="doc:Reminder/cac:ReminderLine/cac:BillingReference/cac:BillingReferenceLine/cac:AllowanceCharge/cac:TaxCategory" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:TierRange) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:TierRange) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB072] TierRange element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:TierRatePercent) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:TierRatePercent) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB073] TierRatePercent element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:ID) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:ID) != ''">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB074] Invalid TaxCategory/ID. Must contain a value.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID/@schemeID = $TaxCategory1_schemeID or cbc:ID/@schemeID = $TaxCategory2_schemeID or cbc:ID/@schemeID = $TaxCategory3_schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID/@schemeID = $TaxCategory1_schemeID or cbc:ID/@schemeID = $TaxCategory2_schemeID or cbc:ID/@schemeID = $TaxCategory3_schemeID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB075] Invalid schemeID. Must be either '<xsl:text />
            <xsl:value-of select="$TaxCategory1_schemeID" />
            <xsl:text />', '<xsl:text />
            <xsl:value-of select="$TaxCategory2_schemeID" />
            <xsl:text />' or '<xsl:text />
            <xsl:value-of select="$TaxCategory3_schemeID" />
            <xsl:text />'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID/@schemeAgencyID = $TaxCategory2_agencyID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID/@schemeAgencyID = $TaxCategory2_agencyID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[W-LIB229] Invalid schemeAgencyID. Must be '320'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="((cbc:ID/@schemeID = $TaxCategory1_schemeID) and not (contains($TaxCategory1, concat(',',cbc:ID,',')))) or ((cbc:ID/@schemeID = $TaxCategory2_schemeID) and not (contains($TaxCategory2, concat(',',cbc:ID,',')))) or ((cbc:ID/@schemeID = $TaxCategory3_schemeID) and not (contains($TaxCategory3, concat(',',cbc:ID,','))))">
      <svrl:successful-report test="((cbc:ID/@schemeID = $TaxCategory1_schemeID) and not (contains($TaxCategory1, concat(',',cbc:ID,',')))) or ((cbc:ID/@schemeID = $TaxCategory2_schemeID) and not (contains($TaxCategory2, concat(',',cbc:ID,',')))) or ((cbc:ID/@schemeID = $TaxCategory3_schemeID) and not (contains($TaxCategory3, concat(',',cbc:ID,','))))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB309] Invalid ID: '<xsl:text />
          <xsl:value-of select="cbc:ID" />
          <xsl:text />'. Must be a value from the codelist</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:Name != '') and not(contains(/doc:Invoice/cbc:ProfileID, 'nesubl.eu'))">
      <svrl:successful-report test="(cbc:Name != '') and not(contains(/doc:Invoice/cbc:ProfileID, 'nesubl.eu'))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[W-LIB230] Name should only be used within NES profiles</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:PerUnitAmount and cbc:Percent">
      <svrl:successful-report test="cbc:PerUnitAmount and cbc:Percent">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB231] Use either PerUnitAmount or Percent</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:PerUnitAmount and not(cbc:BaseUnitMeasure != '')">
      <svrl:successful-report test="cbc:PerUnitAmount and not(cbc:BaseUnitMeasure != '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB232] When PerUnitAmount is used, BaseUnitMeasure is mandatory</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M34" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:ReminderLine/cac:BillingReference/cac:BillingReferenceLine/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme" mode="M34" priority="1004">
    <svrl:fired-rule context="doc:Reminder/cac:ReminderLine/cac:BillingReference/cac:BillingReferenceLine/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:ID) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:ID) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB041] ID element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:AddressTypeCode) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:AddressTypeCode) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB042] AddressTypeCode element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:Postbox) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:Postbox) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB043] Postbox element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:Floor) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:Floor) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB044] Floor element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:Room) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:Room) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB045] Room element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:StreetName) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:StreetName) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB046] StreetName element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:AdditionalStreetName) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:AdditionalStreetName) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB047] AdditionalStreetName element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:BlockName) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:BlockName) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB048] BlockName element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:BuildingName) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:BuildingName) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB049] BuildingName element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:BuildingNumber) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:BuildingNumber) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB050] BuildingNumber element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:InhouseMail) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:InhouseMail) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB051] InhouseMail element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:Department) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:Department) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB052] Department element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:MarkAttention) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:MarkAttention) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB053] MarkAttention element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:MarkCare) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:MarkCare) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB054] MarkCare element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:PlotIdentification) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:PlotIdentification) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB055] PlotIdentification element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:CitySubdivisionName) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:CitySubdivisionName) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB056] CitySubdivisionName element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:CityName) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:CityName) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB057] CityName element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:PostalZone) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:PostalZone) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB058] PostalZone element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:CountrySubentity) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:CountrySubentity) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB059] CountrySubentity element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:CountrySubentityCode) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:CountrySubentityCode) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB060] CountrySubentityCode element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cbc:TimezoneOffset) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cbc:TimezoneOffset) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB063] TimezoneOffset element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cac:AddressLine) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cac:AddressLine) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB234] AddressLine class must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:JurisdictionRegionAddress/cac:LocationCoordinate) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:JurisdictionRegionAddress/cac:LocationCoordinate) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB064] LocationCoordinate class must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:ID = '63') and cbc:TaxTypeCode">
      <svrl:successful-report test="(cbc:ID = '63') and cbc:TaxTypeCode">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB067] TaxTypeCode is not allowed when TaxScheme/ID equals '63' (Moms)</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:ID) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:ID) != ''">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB065] Invalid TaxScheme/ID. Must contain a value.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:Name) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:Name) != ''">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB066] Invalid Name. Must contain a value</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="not((cbc:ID = '63' or cbc:ID = 'VAT')) and not(contains($TaxType2, concat(',',cbc:TaxTypeCode,',')))">
      <svrl:successful-report test="not((cbc:ID = '63' or cbc:ID = 'VAT')) and not(contains($TaxType2, concat(',',cbc:TaxTypeCode,',')))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB197] TaxTypeCode must be a value from the '<xsl:text />
          <xsl:value-of select="$TaxType_listID2" />
          <xsl:text />' codelist when TaxScheme/ID is different from '63' or 'VAT' (Moms)</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID/@schemeID = $TaxScheme_schemeID or cbc:ID/@schemeID = $TaxScheme2_schemeID or cbc:ID/@schemeID = $TaxScheme4_schemeID or cbc:ID/@schemeID = $TaxScheme5_schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID/@schemeID = $TaxScheme_schemeID or cbc:ID/@schemeID = $TaxScheme2_schemeID or cbc:ID/@schemeID = $TaxScheme4_schemeID or cbc:ID/@schemeID = $TaxScheme5_schemeID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB070] Invalid schemeID. Must be either '<xsl:text />
            <xsl:value-of select="$TaxScheme_schemeID" />
            <xsl:text />', '<xsl:text />
            <xsl:value-of select="$TaxScheme2_schemeID" />
            <xsl:text />', '<xsl:text />
            <xsl:value-of select="$TaxScheme4_schemeID" />
            <xsl:text />' or '<xsl:text />
            <xsl:value-of select="$TaxScheme5_schemeID" />
            <xsl:text />'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:TaxTypeCode) and not((cbc:TaxTypeCode/@listID = $TaxType_listID) or (cbc:TaxTypeCode/@listID = $TaxType_listID2))">
      <svrl:successful-report test="(cbc:TaxTypeCode) and not((cbc:TaxTypeCode/@listID = $TaxType_listID) or (cbc:TaxTypeCode/@listID = $TaxType_listID2))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB071] Invalid listID. Must be either '<xsl:text />
          <xsl:value-of select="$TaxType_listID" />
          <xsl:text />' or '<xsl:text />
          <xsl:value-of select="$TaxType_listID2" />
          <xsl:text />'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID = '63') and cbc:Name != 'Moms'">
      <svrl:successful-report test="(cbc:ID = '63') and cbc:Name != 'Moms'">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB198] Name must equal 'Moms' when TaxScheme/ID equals '63' (Moms)</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID != '63') and cbc:Name = 'Moms'">
      <svrl:successful-report test="(cbc:ID != '63') and cbc:Name = 'Moms'">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB199] Name must correspond to the value of TaxScheme/ID</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cac:JurisdictionRegionAddress/cac:Country/cbc:IdentificationCode) and not(contains($CountryCode, concat(',',cac:JurisdictionRegionAddress/cac:Country/cbc:IdentificationCode,',')))">
      <svrl:successful-report test="(cac:JurisdictionRegionAddress/cac:Country/cbc:IdentificationCode) and not(contains($CountryCode, concat(',',cac:JurisdictionRegionAddress/cac:Country/cbc:IdentificationCode,',')))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB337] Invalid Country/IdentificationCode: '<xsl:text />
          <xsl:value-of select="cac:JurisdictionRegionAddress/cac:Country/cbc:IdentificationCode" />
          <xsl:text />'. Must be a value from the country codelist</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cac:JurisdictionRegionAddress) and cac:JurisdictionRegionAddress/cbc:AddressFormatCode != 'StructuredRegion'">
      <svrl:successful-report test="(cac:JurisdictionRegionAddress) and cac:JurisdictionRegionAddress/cbc:AddressFormatCode != 'StructuredRegion'">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB233] The AddressFormatCode under JurisdictionRegionAddress must always equal 'StructuredRegion'</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M34" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:ReminderLine/cac:ExchangeRate" mode="M34" priority="1003">
    <svrl:fired-rule context="doc:Reminder/cac:ReminderLine/cac:ExchangeRate" />

		<!--REPORT -->
<xsl:if test="cac:ForeignExchangeContract and not(normalize-space(cac:ForeignExchangeContract/cbc:ID) != '')">
      <svrl:successful-report test="cac:ForeignExchangeContract and not(normalize-space(cac:ForeignExchangeContract/cbc:ID) != '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB238] Invalid TaxExchangeRate/ForeignExchangeRate/ID. Must contain a value.</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:SourceCurrencyCode) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:SourceCurrencyCode) != ''">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB083] Invalid SourceCurrencyCode. Must contain a value</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:TargetCurrencyCode) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:TargetCurrencyCode) != ''">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB084] Invalid TargetCurrencyCode. Must contain a value</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="cbc:SourceCurrencyBaseRate and (starts-with(cbc:SourceCurrencyBaseRate,'-') or cbc:SourceCurrencyBaseRate = 0)">
      <svrl:successful-report test="cbc:SourceCurrencyBaseRate and (starts-with(cbc:SourceCurrencyBaseRate,'-') or cbc:SourceCurrencyBaseRate = 0)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB085] Invalid SourceCurrencyBaseRate. Must not be negative or zero</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:SourceCurrencyBaseRate and string-length(substring-after(cbc:SourceCurrencyBaseRate, '.')) != 4">
      <svrl:successful-report test="cbc:SourceCurrencyBaseRate and string-length(substring-after(cbc:SourceCurrencyBaseRate, '.')) != 4">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB086] Invalid SourceCurrencyBaseRate. Must have 4 decimals</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:TargetCurrencyBaseRate and (starts-with(cbc:TargetCurrencyBaseRate,'-') or cbc:TargetCurrencyBaseRate = 0)">
      <svrl:successful-report test="cbc:TargetCurrencyBaseRate and (starts-with(cbc:TargetCurrencyBaseRate,'-') or cbc:TargetCurrencyBaseRate = 0)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB087] Invalid TargetCurrencyBaseRate. Must not be negative or zero</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:TargetCurrencyBaseRate and string-length(substring-after(cbc:TargetCurrencyBaseRate, '.')) != 4">
      <svrl:successful-report test="cbc:TargetCurrencyBaseRate and string-length(substring-after(cbc:TargetCurrencyBaseRate, '.')) != 4">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB088] Invalid TargetCurrencyBaseRate. Must have 4 decimals</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:CalculationRate and (starts-with(cbc:CalculationRate,'-') or cbc:CalculationRate = 0)">
      <svrl:successful-report test="cbc:CalculationRate and (starts-with(cbc:CalculationRate,'-') or cbc:CalculationRate = 0)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB089] Invalid CalculationRate. Must not be negative or zero</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:CalculationRate and string-length(substring-after(cbc:CalculationRate, '.')) != 4">
      <svrl:successful-report test="cbc:CalculationRate and string-length(substring-after(cbc:CalculationRate, '.')) != 4">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB090] Invalid CalculationRate. Must have 4 decimals</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:MathematicOperatorCode != 'multiply' and cbc:MathematicOperatorCode != 'divide'">
      <svrl:successful-report test="cbc:MathematicOperatorCode != 'multiply' and cbc:MathematicOperatorCode != 'divide'">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB310] Invalid MathematicOperatorCode. Must either be 'multiply' or 'divide'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:ForeignExchangeContract/cbc:ContractTypeCode and cac:ForeignExchangeContract/cbc:ContractType">
      <svrl:successful-report test="cac:ForeignExchangeContract/cbc:ContractTypeCode and cac:ForeignExchangeContract/cbc:ContractType">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB239] Use either ContractTypeCode or ContractType</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="count(cac:ForeignExchangeContract/cac:ContractDocumentReference) > 1">
      <svrl:successful-report test="count(cac:ForeignExchangeContract/cac:ContractDocumentReference) > 1">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB240] No more than one ContractDocumentReference class may be present</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M34" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:ReminderLine/cac:ExchangeRate/cac:ForeignExchangeContract/cac:ValidityPeriod" mode="M34" priority="1002">
    <svrl:fired-rule context="doc:Reminder/cac:ReminderLine/cac:ExchangeRate/cac:ForeignExchangeContract/cac:ValidityPeriod" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:DurationMeasure) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:DurationMeasure) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB076] DurationMeasure element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:DescriptionCode) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:DescriptionCode) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB077] DescriptionCode element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:StartTime) and (not(cbc:StartDate) or cbc:StartDate = '')">
      <svrl:successful-report test="(cbc:StartTime) and (not(cbc:StartDate) or cbc:StartDate = '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB078] There must be a StartDate if you have a StartTime</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:EndTime) and (not(cbc:EndDate) or cbc:EndDate = '')">
      <svrl:successful-report test="(cbc:EndTime) and (not(cbc:EndDate) or cbc:EndDate = '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB079] There must be a EndDate if you have a EndTime</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:StartDate and cbc:EndDate) and not(number(translate(cbc:EndDate,'-','')) > number(translate(cbc:StartDate,'-','')) or number(translate(cbc:EndDate,'-','')) = number(translate(cbc:StartDate,'-','')))">
      <svrl:successful-report test="(cbc:StartDate and cbc:EndDate) and not(number(translate(cbc:EndDate,'-','')) > number(translate(cbc:StartDate,'-','')) or number(translate(cbc:EndDate,'-','')) = number(translate(cbc:StartDate,'-','')))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB080] The EndDate must be greater or equal to the startdate</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:StartTime and cbc:EndTime) and not(number(translate(cbc:EndTime,':','')) > number(translate(cbc:StartTime,':','')) or number(translate(cbc:EndTime,':','')) = number(translate(cbc:StartTime,':','')))">
      <svrl:successful-report test="(cbc:StartTime and cbc:EndTime) and not(number(translate(cbc:EndTime,':','')) > number(translate(cbc:StartTime,':','')) or number(translate(cbc:EndTime,':','')) = number(translate(cbc:StartTime,':','')))">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB081] EndTime must be greater or equal to StartTime</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M34" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:ReminderLine/cac:ExchangeRate/cac:ForeignExchangeContract/cac:ValidityPeriod/cbc:Description" mode="M34" priority="1001">
    <svrl:fired-rule context="doc:Reminder/cac:ReminderLine/cac:ExchangeRate/cac:ForeignExchangeContract/cac:ValidityPeriod/cbc:Description" />

		<!--REPORT -->
<xsl:if test="count(../cbc:Description) > 1 and not(./@languageID)">
      <svrl:successful-report test="count(../cbc:Description) > 1 and not(./@languageID)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[W-LIB222] The attribute languageID should be used when more than one Description element is present</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID">
      <svrl:successful-report test="local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[W-LIB223] Multilanguage error. Replicated Description elements with same languageID attribute value</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M34" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="doc:Reminder/cac:ReminderLine/cac:ExchangeRate/cac:ForeignExchangeContract/cac:ContractDocumentReference" mode="M34" priority="1000">
    <svrl:fired-rule context="doc:Reminder/cac:ReminderLine/cac:ExchangeRate/cac:ForeignExchangeContract/cac:ContractDocumentReference" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:DocumentType) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:DocumentType) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB170] DocumentType element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:DocumentTypeCode) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:DocumentTypeCode) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[F-LIB172] DocumentTypeCode element must be excluded</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="cac:Attachment and cbc:XPath">
      <svrl:successful-report test="cac:Attachment and cbc:XPath">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB169] Use either Attachment or XPath</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Attachment/cbc:EmbeddedDocumentBinaryObject and cac:Attachment/cac:ExternalReference">
      <svrl:successful-report test="cac:Attachment/cbc:EmbeddedDocumentBinaryObject and cac:Attachment/cac:ExternalReference">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB171] Use either EmbeddedDocumentBinaryObject or ExternalReference</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:UUID and not(string-length(string(cbc:UUID)) = 36)">
      <svrl:successful-report test="cbc:UUID and not(string-length(string(cbc:UUID)) = 36)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB173] Invalid UUID. Must be of this form '6E09886B-DC6E-439F-82D1-7CCAC7F4E3B1'</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Attachment/cbc:EmbeddedDocumentBinaryObject and not(cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/tiff' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/png' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/jpeg' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/gif' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/pdf' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='text/xml' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='text/csv' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.ms-excel' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.oasis.opendocument.spreadsheet')">
      <svrl:successful-report test="cac:Attachment/cbc:EmbeddedDocumentBinaryObject and not(cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/tiff' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/png' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/jpeg' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/gif' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/pdf' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='text/xml' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='text/csv' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.ms-excel' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/vnd.oasis.opendocument.spreadsheet')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB174] Attribute mimeCode must be a value from the codelist</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Attachment/cac:ExternalReference and not(cac:Attachment/cac:ExternalReference/cbc:URI != '')">
      <svrl:successful-report test="cac:Attachment/cac:ExternalReference and not(cac:Attachment/cac:ExternalReference/cbc:URI != '')">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>[F-LIB096] When using ExternalReference, URI is mandatory</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M34" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M34" priority="-1" />
  <xsl:template match="@*|node()" mode="M34" priority="-2">
    <xsl:apply-templates mode="M34" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
</xsl:stylesheet>
