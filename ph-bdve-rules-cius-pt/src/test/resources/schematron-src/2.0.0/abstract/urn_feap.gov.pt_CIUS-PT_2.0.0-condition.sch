<pattern xmlns="http://purl.oclc.org/dsdl/schematron" abstract="true" id="condition">
  <rule context="$Amount_due ">
    <assert test="$BR-CO-25" flag="fatal" id="BR-CO-25">[BR-CO-25]-In case the Amount due for payment (BT-115) is positive, either the Payment due date (BT-9) or the Payment terms (BT-20) shall be present.</assert>
  </rule>
  <rule context="$Invoice ">
    <assert test="$BR-AA-01" flag="fatal" id="BR-AA-01">[BR-AA-01]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is “Lower rate” shall contain in the VATBReakdown (BG-23) at least one VAT category code (BT-118) equal with "Lower rate".</assert>
    <assert test="$BR-S-01" flag="fatal" id="BR-S-01">[BR-S-01]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is “Standard rated” shall contain in the VATBReakdown (BG-23) at least one VAT category code (BT-118) equal with "Standard rated".</assert>
    <assert test="$BR-E-01" flag="fatal" id="BR-E-01">[BR-E-01]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is “Exempt from VAT” shall contain exactly one VATBReakdown (BG-23) with the VAT category code (BT-118) equal to "Exempt from VAT".</assert>
    <assert test="$DT-CIUS-PT-165" flag="fatal" id="DT-CIUS-PT-165">[DT-CIUS-PT-165]-Invoice total amount with VAT (BT-112) = Invoice total amount without VAT (BT-109) + Invoice total VAT amount (BT-110), with an acceptance range of 0.04 € (it does not mean that this tolerance is accepted by the customer).</assert>
  </rule>
  <rule context="$Invoice_Line ">
    <assert test="$BR-28" flag="fatal" id="BR-28">[BR-28]-The Item gross price (BT-148) shall NOT be negative.</assert>
    <assert test="$BR-27" flag="fatal" id="BR-27">[BR-27]-The Item net price (BT-146) shall NOT be negative.</assert>
    <assert test="$BR-CO-04" flag="fatal" id="BR-CO-04">[BR-CO-04]-Each Invoice line (BG-25) shall be categorized with an Invoiced item VAT category code (BT-151).</assert>
    <assert test="$DT-CIUS-PT-157" flag="fatal" id="DT-CIUS-PT-157">[DT-CIUS-PT-157]-The BT-131  must equal the multiplication between the quantity (InvoicedQuantity) and the price (PriceAmount) divided by the base quantity (BaseQuantity) subtracted by the sum of the discounts and added the sum of the charges of the line, with an acceptance range of 0.04 € (it does not mean that this tolerance is accepted by the customer).</assert>
  </rule>
  <rule context="$Payee ">
    <assert test="$BR-17" flag="fatal" id="BR-17">[BR-17]-The Payee name (BT-59) shall be provided in the Invoice, if the Payee (BG-10) is different from the Seller (BG-4)</assert>
    <assert test="$UBL-SR-19" flag="warning" id="UBL-SR-19">[UBL-SR-19]-Payee name shall occur maximum once, if the Payee is different from the Seller</assert>
    <assert test="$UBL-SR-20" flag="warning" id="UBL-SR-20">[UBL-SR-20]-Payee identifier shall occur maximum once, if the Payee is different from the Seller</assert>
    <assert test="$UBL-SR-21" flag="warning" id="UBL-SR-21">[UBL-SR-21]-Payee legal registration identifier shall occur maximum once, if the Payee is different from the Seller</assert>
  </rule>
  <rule context="$Tax_Total ">
    <assert test="$DT-CIUS-PT-164" flag="fatal" id="DT-CIUS-PT-164">[DT-CIUS-PT-164]-Invoice total VAT amount (BT-110) = Σ VAT category tax amount (BT-117), with an acceptance range of 0.04 € (it does not mean that this tolerance is accepted by the customer).</assert>
  </rule>
  <rule context="$Document_totals ">
    <assert test="$DT-CIUS-PT-160" flag="fatal" id="DT-CIUS-PT-160">[DT-CIUS-PT-160]-Sum of Invoice line net amount (BT-106) = Σ Invoice line net amount (BT-131), with an acceptance range of 0.04 € (it does not mean that this tolerance is accepted by the customer).</assert>
    <assert test="$DT-CIUS-PT-161" flag="fatal" id="DT-CIUS-PT-161">[DT-CIUS-PT-161]-Sum of allowances on document level (BT-107) = Σ Document level allowance amount (BT-92), with an acceptance range of 0.04 € (it does not mean that this tolerance is accepted by the customer).</assert>    
    <assert test="$DT-CIUS-PT-162" flag="fatal" id="DT-CIUS-PT-162">[DT-CIUS-PT-162]-Sum of charges on document level (BT-108) = Σ Document level charge amount (BT-99), with an acceptance range of 0.04 € (it does not mean that this tolerance is accepted by the customer).</assert>
    <assert test="$DT-CIUS-PT-163" flag="fatal" id="DT-CIUS-PT-163">[DT-CIUS-PT-163]-Invoice total amount without VAT (BT-109) = Σ Invoice line net amount (BT-131) - Sum of allowances on document level (BT-107) + Sum of charges on document level (BT-108), with an acceptance range of 0.04 € (it does not mean that this tolerance is accepted by the customer).</assert>
    <assert test="$DT-CIUS-PT-166" flag="fatal" id="DT-CIUS-PT-166">[DT-CIUS-PT-166]-Amount due for payment (BT-115) = Invoice total amount with VAT (BT-112) -Paid amount (BT-113) +Rounding amount (BT-114), with an acceptance range of 0.04 € (it does not mean that this tolerance is accepted by the customer).</assert>
  </rule>
  <rule context="$Document_level_charges ">
    <assert test="$DT-CIUS-PT-159" flag="fatal" id="DT-CIUS-PT-159">[DT-CIUS-PT-159]-The BT-99 must equal the multiplication between the Document level charge base amount (BT-100) and the Document level charge percentage (BT-101), with an acceptance range of 0.04 € (it does not mean that this tolerance is accepted by the customer).</assert>    
  </rule>
  <rule context="$Document_level_allowances ">
    <assert test="$DT-CIUS-PT-158" flag="fatal" id="DT-CIUS-PT-158">[DT-CIUS-PT-158]-The BT-92 must equal the multiplication between the Document level allowance base amount (BT-93) and the Document level allowance percentage (BT-94), with an acceptance range of 0.04 € (it does not mean that this tolerance is accepted by the customer).</assert>
  </rule>
  <rule context="$VAT_breakdown ">
    <assert test="$DT-CIUS-PT-167" flag="fatal" id="DT-CIUS-PT-167">[DT-CIUS-PT-167]-VAT category tax amount (BT-117) = VAT category taxable amount (BT-116) x (VAT category rate (BT-119) / 100), rounded to two decimals and with an acceptance range of 0.04 € (it does not mean that this tolerance is accepted by the customer).</assert>
  </rule>
  <rule context="$VATAA ">
    <assert test="$DT-CIUS-PT-171" flag="fatal" id="DT-CIUS-PT-171">[DT-CIUS-PT-171]-For each different value of VAT category rate (BT-119) where the VAT category code (BT-118) is "Lower rate", the VAT category taxable amount (BT-116) in a VATBReakdown (BG-23) shall equal the sum of Invoice line net amounts (BT-131) plus the sum of document level charge amounts (BT-99) minus the sum of document level allowance amounts (BT-92) where the VAT category code (BT-151, BT-102, BT-95) is “Lower rate” and the VAT rate (BT-152, BT-103, BT-96) equals the VAT category rate (BT-119), with an acceptance range of 0.04 € (it does not mean that this tolerance is accepted by the customer).</assert>
    <assert test="$DT-CIUS-PT-172" flag="fatal" id="DT-CIUS-PT-172">[DT-CIUS-PT-172]-The VAT category tax amount (BT-117) in a VATBReakdown (BG-23) where VAT category code (BT-118) is "Lower rate" shall equal the VAT category taxable amount (BT-116) multiplied by the VAT category rate (BT-119), with an acceptance range of 0.04 € (it does not mean that this tolerance is accepted by the customer).</assert> 
    <assert test="$BR-CIUS-PT-12" flag="fatal" id="BR-CIUS-PT-12">[BR-CIUS-PT-12]-A VATBReakdown (BG-23) with VAT Category code (BT-118) "Lower rate" the VAT category rate (BT-119) shall be greater than zero.</assert>
  </rule>
  <rule context="$VATAA_Allowance ">
    <assert test="$BR-AA-06" flag="fatal" id="BR-AA-06">[BR-AA-06]-In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Lower rate" the Document level allowance VAT rate (BT-96) shall be greater than zero.</assert>
  </rule>
  <rule context="$VATAA_Charge ">
    <assert test="$BR-AA-07" flag="fatal" id="BR-AA-07">[BR-AA-07]-In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Lower rate" the Document level charge VAT rate (BT-103) shall be greater than zero.  </assert>
  </rule>
  <rule context="$VATS ">
    <assert test="$DT-CIUS-PT-173" flag="fatal" id="DT-CIUS-PT-173">[DT-CIUS-PT-173]-For each different value of VAT category rate (BT-119) where the VAT category code (BT-118) is "Standard rated", the VAT category taxable amount (BT-116) in a VATBReakdown (BG-23) shall equal the sum of Invoice line net amounts (BT-131) plus the sum of document level charge amounts (BT-99) minus the sum of document level allowance amounts (BT-92) where the VAT category code (BT-151, BT-102, BT-95) is “Standard rated” and the VAT rate (BT-152, BT-103, BT-96) equals the VAT category rate (BT-119), with an acceptance range of 0.04 € (it does not mean that this tolerance is accepted by the customer).</assert>
    <assert test="$DT-CIUS-PT-174" flag="fatal" id="DT-CIUS-PT-174">[DT-CIUS-PT-174]-The VAT category tax amount (BT-117) in a VATBReakdown (BG-23) where VAT category code (BT-118) is "Standard rated" shall equal the VAT category taxable amount (BT-116) multiplied by the VAT category rate (BT-119), with an acceptance range of 0.04 € (it does not mean that this tolerance is accepted by the customer).</assert>
    <assert test="$BR-CIUS-PT-14" flag="fatal" id="BR-CIUS-PT-14">[BR-CIUS-PT-14]-A VATBReakdown (BG-23) with VAT Category code (BT-118) "Standard rate" the VAT category rate (BT-119) shall be greater than zero.</assert>
  </rule>
  <rule context="$VATS_Allowance ">
    <assert test="$BR-S-06" flag="fatal" id="BR-S-06">[BR-S-06]-In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Standard rated" the Document level allowance VAT rate (BT-96) shall be greater than zero.</assert>
  </rule>
  <rule context="$VATS_Charge ">
    <assert test="$BR-S-07" flag="fatal" id="BR-S-07">[BR-S-07]-In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Standard rated" the Document level charge VAT rate (BT-103) shall be greater than zero.  </assert>
  </rule>
  <rule context="$VATE ">
    <assert test="$BR-E-08" flag="fatal" id="BR-E-08">[BR-E-08]-In a VATBReakdown (BG-23) where the VAT category code (BT-118) is "Exempt from VAT" the VAT category taxable amount (BT-116) shall equal the sum of Invoice line net amounts (BT-131) minus the sum of Document level allowance amounts (BT-92) plus the sum of Document level charge amounts (BT-99) where the VAT category codes (BT-151, BT-95, BT-102) are “Exempt from VAT".</assert>
    <assert test="$BR-E-09" flag="fatal" id="BR-E-09">[BR-E-09]-The VAT category tax amount (BT-117) In a VATBReakdown (BG-23) where the VAT category code (BT-118) equals "Exempt from VAT" shall equal 0 (zero).</assert>
    <assert test="$BR-CIUS-PT-16" flag="fatal" id="BR-CIUS-PT-16">[BR-CIUS-PT-16]-A VATBReakdown (BG-23) with VAT Category code (BT-118) "Exempt from VAT" the VAT category rate (BT-119) shall be 0 (zero).</assert>
  </rule>
  <rule context="$VATE_Allowance ">
    <assert test="$BR-E-06" flag="fatal" id="BR-E-06">[BR-E-06]-In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Exempt from VAT", the Document level allowance VAT rate (BT-96) shall be 0 (zero).</assert>
  </rule>
  <rule context="$VATE_Charge ">
    <assert test="$BR-E-07" flag="fatal" id="BR-E-07">[BR-E-07]-In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Exempt from VAT", the Document level charge VAT rate (BT-103) shall be 0 (zero).    </assert>
  </rule>
  <rule context="$Invoice_line_charges ">
    <assert test="$DT-CIUS-PT-169" flag="fatal" id="DT-CIUS-PT-169">[DT-CIUS-PT-169]-The BT-141 must equal the multiplication between the Invoice line charge base amount (BT-142) and the Invoice line charge percentage (BT-143), with an acceptance range of 0.04 € (it does not mean that this tolerance is accepted by the customer).</assert>
  </rule>
  <rule context="$Invoice_line_allowances ">
    <assert test="$DT-CIUS-PT-168" flag="fatal" id="DT-CIUS-PT-168">[DT-CIUS-PT-168]-The BT-136 must equal the multiplication between the Invoice line allowance base amount (BT-137) and the Invoice line allowance percentage (BT-138), with an acceptance range of 0.04 € (it does not mean that this tolerance is accepted by the customer).</assert>
  </rule>
  <rule context="$Invoice_Line_Price ">
    <assert test="$DT-CIUS-PT-170" flag="fatal" id="DT-CIUS-PT-170">[DT-CIUS-PT-170]-The BT-146 must equal the grossPrice (Item gross price) minus the discount (Item price discount), with an acceptance range of 0.04 € (it does not mean that this tolerance is accepted by the customer).</assert>
  </rule>
  <rule context="$VATAA_Line ">
    <assert test="$BR-AA-05" flag="fatal" id="BR-AA-05">[BR-AA-05]-In a Line VAT Information (BG-30) where the Invoiced item VAT category code (BT-151) is "Lower rate" the Invoiced item VAT rate (BT-152) shall be greater than zero.</assert>
  </rule>
  <rule context="$VATS_Line ">
    <assert test="$BR-S-05" flag="fatal" id="BR-S-05">[BR-S-05]-In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Standard rated" the Invoiced item VAT rate (BT-152) shall be greater than zero.    </assert>
  </rule>
  <rule context="$VATE_Line ">
    <assert test="$BR-E-05" flag="fatal" id="BR-E-05">[BR-E-05]-In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Exempt from VAT", the Invoiced item VAT rate (BT-152) shall be 0 (zero).    </assert>
  </rule>
</pattern>
