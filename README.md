# PHIVE rules

A set of preconfigured rules for PHIVE (Philip Helger Integrative Validation Engine).

All projects found in here rely on the PHIVE validation engine provided by https://github.com/phax/phive (formerly ph-bdve)

This project is divided into sub-projects each keeping tracking of one document type set:
  * phive-rules-cii - Validation rules for pure CII (without any Schematron)
  * phive-rules-cius-pt - Validation rules for the Portuguese EN 16931 CIUS (since v1.0.11)
  * phive-rules-ebinterface - Validation rules for Austrian ebInterface
  * phive-rules-ehf - Validation rules for EHF (Norwegian public procurement)
  * phive-rules-en16931 - Validation rules for the EN 16931 (European e-Invoicing norm based on CEN TC 434)
  * phive-rules-energieefactuur - Validation rules for Dutch Energie eFactuur
  * phive-rules-facturae - Validation rules for the Spanisch Facturae (since v1.0.11)
  * phive-rules-fatturapa - Validation rules for Italian fattura PA (since v1.0.4)
  * phive-rules-finvoice - Validation rules for Finvoice (since v1.0.6)
  * phive-rules-oioubl - Validation rules for Danish OIOUBL
  * phive-rules-peppol - the Peppol specific setup etc
  * phive-rules-simplerinvoicing - Dutch SimplerInvoicing 1.x support from https://github.com/SimplerInvoicing/validation
  * phive-rules-svefaktura - Validation rules for Svefaktura (since v1.0.6)
  * phive-rules-teapps - Validation rules for Tieto TEAPPSXML
  * phive-rules-ubl - Validation rules for pure UBL (without any Schematron)
  * phive-rules-ublbe - Validation rules for e-FFF/UBL.BE
  * phive-rules-xrechnung - Validation rules for German XRechnung

The Java code in this project is licensed under the Apache 2 license.
The code of the validation artefacts used may use a different license. 

# Maven usage

Add the following to your `pom.xml` to use this artifact, replacing `x.y.z` with the latest version:

```xml
<dependency>
  <groupId>com.helger.phive.rules</groupId>
  <artifactId>phive-rules-cii</artifactId>
  <version>x.y.z</version>
</dependency>

<dependency>
  <groupId>com.helger.phive.rules</groupId>
  <artifactId>phive-rules-cius-pt</artifactId>
  <version>x.y.z</version>
</dependency>

<dependency>
  <groupId>com.helger.phive.rules</groupId>
  <artifactId>phive-rules-ebinterface</artifactId>
  <version>x.y.z</version>
</dependency>

<dependency>
  <groupId>com.helger.phive.rules</groupId>
  <artifactId>phive-rules-ehf</artifactId>
  <version>x.y.z</version>
</dependency>

<dependency>
  <groupId>com.helger.phive.rules</groupId>
  <artifactId>phive-rules-en16931</artifactId>
  <version>x.y.z</version>
</dependency>

<dependency>
  <groupId>com.helger.phive.rules</groupId>
  <artifactId>phive-rules-energieefactuur</artifactId>
  <version>x.y.z</version>
</dependency>

<dependency>
  <groupId>com.helger.phive.rules</groupId>
  <artifactId>phive-rules-facturae</artifactId>
  <version>x.y.z</version>
</dependency>

<dependency>
  <groupId>com.helger.phive.rules</groupId>
  <artifactId>phive-rules-fatturapa</artifactId>
  <version>x.y.z</version>
</dependency>

<dependency>
  <groupId>com.helger.phive.rules</groupId>
  <artifactId>phive-rules-finvoice</artifactId>
  <version>x.y.z</version>
</dependency>

<dependency>
  <groupId>com.helger.phive.rules</groupId>
  <artifactId>phive-rules-oioubl</artifactId>
  <version>x.y.z</version>
</dependency>

<dependency>
  <groupId>com.helger.phive.rules</groupId>
  <artifactId>phive-rules-peppol</artifactId>
  <version>x.y.z</version>
</dependency>

<dependency>
  <groupId>com.helger.phive.rules</groupId>
  <artifactId>phive-rules-simplerinvoicing</artifactId>
  <version>x.y.z</version>
</dependency>

<dependency>
  <groupId>com.helger.phive.rules</groupId>
  <artifactId>phive-rules-svefaktura</artifactId>
  <version>x.y.z</version>
</dependency>

<dependency>
  <groupId>com.helger.phive.rules</groupId>
  <artifactId7>phive-rules-teapps</artifactId>
  <version>x.y.z</version>
</dependency>

<dependency>
  <groupId>com.helger.phive.rules</groupId>
  <artifactId>phive-rules-ubl</artifactId>
  <version>x.y.z</version>
</dependency>

<dependency>
  <groupId>com.helger.phive.rules</groupId>
  <artifactId>phive-rules-ublbe</artifactId>
  <version>x.y.z</version>
</dependency>

<dependency>
  <groupId>com.helger.phive.rules</groupId>
  <artifactId>phive-rules-xrechnung</artifactId>
  <version>x.y.z</version>
</dependency>
```

Alternate usage as a Maven BOM:

```xml
<dependency>
  <groupId>com.helger.phive.rules</groupId>
  <artifactId>phive-rules-parent-pom</artifactId>
  <version>x.y.z</version>
  <type>pom</type>
  <scope>import</scope>
</dependency>
```
  
# News and noteworthy

* v2.0.0 - 2020-11-25
    * Renamed modules from `ph-bdve-rules-*` to `phive-rules*`
    * Changed the Maven group from `com.helger.bdve.rules.*` to `com.helger.phive.rules.*`
    * Named the Maven artefacts from `ph-bdve-rules-*` to `phive-rules-*`
    * Updated to ph-schematron 6.0.0
    * Added support for UBL.BE 1.2.6, deprecated version 1.2.5
* v1.0.15 - 2020-11-24
    * Added A-NZ-PEPPOL 1.0.4 rules
* v1.0.14 - 2020-11-18
    * Added support for UBL.BE 1.2.5, deprecated version 1.2.3
    * Deprecated Peppol validation artefacts 3.10.1 and 3.11.0
* v1.0.13 - 2020-11-13
    * Added Peppol Fall 2020 release corrigendum as version 3.11.1
* v1.0.12 - 2020-11-12
    * Same as 1.0.11 - just re-released because I thought it was lost on the way to Maven Central
* v1.0.11 - 2020-11-12
    * Updated to ph-bdve engine 6.0.4
    * Fixed an error with the XRechnung 2.0.0 validation artefacts
    * Added support for Spanish Facturae (version 3.0, 3.1, 3.2, 3.2.1 and 3.2.2) - in the submodule `ph-bdve-rules-facturae`
    * Added support for Portuguese CIUS-PT (version 2.0.0) - in the submodule `ph-bdve-rules-cius-pt`
* v1.0.10 - 2020-11-06
    * Added support for XRechnung 2.0.0 - thanks to [@yleider](https://github.com/yleider) for the PR
* v1.0.9 - 2020-11-02
    * Added Peppol Fall 2020 release as version 3.11.0
* v1.0.8 - 2020-10-05
    * Added support for EN 16931 1.3.3 format (deprecated version 1.3.2)
* v1.0.7 - 2020-09-17
    * Updated to Jakarta JAXB 2.3.3
* v1.0.6 - 2020-08-30
    * Added support for Finvoice 1.3, 2.0, 2.01 and 3.0
    * Added Svefaktura 1.0 and Svefaktura ObjectEnvelope 1.0
    * Updated to UBL 2.3 CSD03
* v1.0.5 - 2020-07-22
    * Added support for UBL.BE 1.2.3 rules
* v1.0.4 - 2020-07-06
    * Added support for Italian fatturaPA 1.2 and 1.2.1
    * Deprecated Peppol 3.10.0 rules
    * A Hotfix to the Peppol 3.10.1 rules, only relevant for "0208" participant identifier scheme usage, was included
    * Added SG-PEPPOL 1.0.3 rules
    * Added A-NZ-PEPPOL 1.0.3 rules
* v1.0.3 - 2020-06-16
    * Added Peppol Spring 2020 Hotfix release as version 3.10.1
* v1.0.2 - 2020-06-15
    * EHF G2 rules no longer directly use the Peppol rules but the provided subsets
* v1.0.1 - 2020-06-10
    * Added support for EHF G3 version 2020-03-23
    * Updated the Peppol 3.10.0 VESIDs to contain the document types
* v1.0.0 - 2020-06-08
    * Extracted from ph-bdve to allow for a clear separation between the engine and rules
    * Therefore a new Maven group `com.helger.bdve.rules` was created

---

My personal [Coding Styleguide](https://github.com/phax/meta/blob/master/CodingStyleguide.md) |
On Twitter: <a href="https://twitter.com/philiphelger">@philiphelger</a> |
Kindly supported by [YourKit Java Profiler](https://www.yourkit.com)
