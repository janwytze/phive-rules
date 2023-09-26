/*
 * Copyright (C) 2014-2023 Philip Helger (www.helger.com)
 * philip[at]helger[dot]com
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *         http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.helger.phive.peppol.mock;

import static org.junit.Assert.assertTrue;

import javax.annotation.Nonnull;
import javax.annotation.concurrent.Immutable;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.annotation.ReturnsMutableCopy;
import com.helger.commons.collection.impl.CommonsArrayList;
import com.helger.commons.collection.impl.ICommonsList;
import com.helger.commons.io.resource.FileSystemResource;
import com.helger.commons.io.resource.IReadableResource;
import com.helger.diver.api.version.VESID;
import com.helger.phive.api.executorset.ValidationExecutorSetRegistry;
import com.helger.phive.api.mock.TestFile;
import com.helger.phive.peppol.PeppolValidation;
import com.helger.phive.peppol.PeppolValidation2023_05;
import com.helger.phive.peppol.PeppolValidation3_15_0;
import com.helger.phive.peppol.PeppolValidationAUNZ;
import com.helger.phive.peppol.PeppolValidationDirectory;
import com.helger.phive.peppol.PeppolValidationJP;
import com.helger.phive.peppol.PeppolValidationReporting;
import com.helger.phive.peppol.PeppolValidationSG;
import com.helger.phive.xml.source.IValidationSourceXML;

@Immutable
@SuppressWarnings ("deprecation")
public final class CTestFiles
{
  public static final ValidationExecutorSetRegistry <IValidationSourceXML> VES_REGISTRY = new ValidationExecutorSetRegistry <> ();
  static
  {
    PeppolValidation.initStandard (VES_REGISTRY);
  }

  private CTestFiles ()
  {}

  @Nonnull
  @ReturnsMutableCopy
  public static ICommonsList <TestFile> getAllTestFiles ()
  {
    final ICommonsList <TestFile> ret = new CommonsArrayList <> ();
    for (final VESID aESID : new VESID [] { /* AU_NZ */
                                            PeppolValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_107,
                                            PeppolValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_107,
                                            PeppolValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_107,
                                            PeppolValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_107,

                                            PeppolValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_108,
                                            PeppolValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_108,
                                            PeppolValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_108,
                                            PeppolValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_108,

                                            PeppolValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_109,
                                            PeppolValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_109,
                                            PeppolValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_109,
                                            PeppolValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_109,

                                            /* Singapore */
                                            PeppolValidationSG.VID_OPENPEPPOL_BIS3_SG_UBL_INVOICE_102,
                                            PeppolValidationSG.VID_OPENPEPPOL_BIS3_SG_UBL_CREDIT_NOTE_102,

                                            PeppolValidationSG.VID_OPENPEPPOL_BIS3_SG_UBL_INVOICE_103,
                                            PeppolValidationSG.VID_OPENPEPPOL_BIS3_SG_UBL_CREDIT_NOTE_103,

                                            /* OpenPeppol */
                                            PeppolValidation3_15_0.VID_OPENPEPPOL_INVOICE_UBL_V3,
                                            PeppolValidation3_15_0.VID_OPENPEPPOL_CREDIT_NOTE_UBL_V3,
                                            PeppolValidation3_15_0.VID_OPENPEPPOL_INVOICE_CII_V3,
                                            PeppolValidation3_15_0.VID_OPENPEPPOL_ORDER_V3,
                                            PeppolValidation3_15_0.VID_OPENPEPPOL_DESPATCH_ADVICE_V3,
                                            PeppolValidation3_15_0.VID_OPENPEPPOL_CATALOGUE_V3,
                                            PeppolValidation3_15_0.VID_OPENPEPPOL_CATALOGUE_RESPONSE_V3,
                                            PeppolValidation3_15_0.VID_OPENPEPPOL_MLR_V3,
                                            PeppolValidation3_15_0.VID_OPENPEPPOL_ORDER_RESPONSE_V3,
                                            PeppolValidation3_15_0.VID_OPENPEPPOL_PUNCH_OUT_V3,
                                            PeppolValidation3_15_0.VID_OPENPEPPOL_ORDER_AGREEMENT_V3,
                                            PeppolValidation3_15_0.VID_OPENPEPPOL_INVOICE_MESSAGE_RESPONSE_V3,

                                            PeppolValidation2023_05.VID_OPENPEPPOL_INVOICE_UBL_V3,
                                            PeppolValidation2023_05.VID_OPENPEPPOL_CREDIT_NOTE_UBL_V3,
                                            // PeppolValidation2023_05.VID_OPENPEPPOL_INVOICE_CII_V3,
                                            PeppolValidation2023_05.VID_OPENPEPPOL_ORDER_V3,
                                            PeppolValidation2023_05.VID_OPENPEPPOL_DESPATCH_ADVICE_V3,
                                            PeppolValidation2023_05.VID_OPENPEPPOL_CATALOGUE_V3,
                                            PeppolValidation2023_05.VID_OPENPEPPOL_CATALOGUE_RESPONSE_V3,
                                            PeppolValidation2023_05.VID_OPENPEPPOL_MLR_V3,
                                            PeppolValidation2023_05.VID_OPENPEPPOL_ORDER_RESPONSE_V3,
                                            PeppolValidation2023_05.VID_OPENPEPPOL_PUNCH_OUT_V3,
                                            PeppolValidation2023_05.VID_OPENPEPPOL_ORDER_AGREEMENT_V3,
                                            PeppolValidation2023_05.VID_OPENPEPPOL_INVOICE_MESSAGE_RESPONSE_V3,
                                            PeppolValidation2023_05.VID_OPENPEPPOL_ORDER_CHANGE_V3,
                                            PeppolValidation2023_05.VID_OPENPEPPOL_ORDER_CANCELLATION_V3,
                                            PeppolValidation2023_05.VID_OPENPEPPOL_ORDER_RESPONSE_ADVANCED_V3,

                                            /* Directory */
                                            PeppolValidationDirectory.VID_OPENPEPPOL_BUSINESS_CARD_V1,
                                            PeppolValidationDirectory.VID_OPENPEPPOL_BUSINESS_CARD_V2,
                                            PeppolValidationDirectory.VID_OPENPEPPOL_BUSINESS_CARD_V3,

                                            /* Reporting */
                                            PeppolValidationReporting.VID_OPENPEPPOL_EUSR_V100RC2,
                                            PeppolValidationReporting.VID_OPENPEPPOL_EUSR_V100,
                                            PeppolValidationReporting.VID_OPENPEPPOL_EUSR_V101,
                                            PeppolValidationReporting.VID_OPENPEPPOL_EUSR_V110,
                                            PeppolValidationReporting.VID_OPENPEPPOL_EUSR_V111,

                                            PeppolValidationReporting.VID_OPENPEPPOL_TSR_V100,
                                            PeppolValidationReporting.VID_OPENPEPPOL_TSR_V101,
                                            PeppolValidationReporting.VID_OPENPEPPOL_TSR_V102,

                                            /* Japan */
                                            PeppolValidationJP.VID_OPENPEPPOL_JP_PINT_INVOICE_012,
                                            PeppolValidationJP.VID_OPENPEPPOL_JP_PINT_CREDIT_NOTE_012 })
      for (final IReadableResource aRes : getAllMatchingTestFiles (aESID))
      {
        assertTrue ("Not existing test file: " + aRes.getPath (), aRes.exists ());
        ret.add (TestFile.createGoodCase (aRes, aESID));
      }
    return ret;
  }

  @Nonnull
  @ReturnsMutableCopy
  public static ICommonsList <? extends IReadableResource> getAllMatchingTestFiles (@Nonnull final VESID aVESID)
  {
    ValueEnforcer.notNull (aVESID, "VESID");

    final String sPrefix0 = "src/test/resources/external/test-files/";

    // AUNZ 1.0.7
    if (aVESID.equals (PeppolValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_107))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.7/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "AU Invoice.xml"),
                                      new FileSystemResource (sPrefix + "NZ Allowance On Invoice Line.xml"),
                                      new FileSystemResource (sPrefix + "NZ Invoice Level Allowance.xml"),
                                      new FileSystemResource (sPrefix + "NZ Invoice Level Charge.xml"),
                                      new FileSystemResource (sPrefix + "NZ No Allowances.xml"),
                                      new FileSystemResource (sPrefix + "NZ Prepaid Amount.xml"));
    }
    if (aVESID.equals (PeppolValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_107))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.7/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "NZ Credit note.xml"));
    }
    if (aVESID.equals (PeppolValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_107))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.7/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "AU Self Billing.xml"),
                                      new FileSystemResource (sPrefix + "NZ Self Billing.xml"));
    }
    if (aVESID.equals (PeppolValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_107))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.7/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "NZ Self Billed Credit note.xml"));
    }

    // AUNZ 1.0.8
    if (aVESID.equals (PeppolValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_108))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.8/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "AU Invoice.xml"),
                                      new FileSystemResource (sPrefix + "NZ Allowance On Invoice Line.xml"),
                                      new FileSystemResource (sPrefix + "NZ Invoice Level Allowance.xml"),
                                      new FileSystemResource (sPrefix + "NZ Invoice Level Charge.xml"),
                                      new FileSystemResource (sPrefix + "NZ No Allowances.xml"),
                                      new FileSystemResource (sPrefix + "NZ Prepaid Amount.xml"));
    }
    if (aVESID.equals (PeppolValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_108))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.8/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "NZ Credit note.xml"));
    }
    if (aVESID.equals (PeppolValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_108))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.8/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "AU Self Billing.xml"),
                                      new FileSystemResource (sPrefix + "NZ Self Billing.xml"));
    }
    if (aVESID.equals (PeppolValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_108))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.8/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "NZ Self Billed Credit note.xml"));
    }

    // AUNZ 1.0.9
    if (aVESID.equals (PeppolValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_109))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.9/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "AU Invoice.xml"),
                                      new FileSystemResource (sPrefix + "NZ Allowance On Invoice Line.xml"),
                                      new FileSystemResource (sPrefix + "NZ Invoice Level Allowance.xml"),
                                      new FileSystemResource (sPrefix + "NZ Invoice Level Charge.xml"),
                                      new FileSystemResource (sPrefix + "NZ No Allowances.xml"),
                                      new FileSystemResource (sPrefix + "NZ Prepaid Amount.xml"));
    }
    if (aVESID.equals (PeppolValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_109))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.9/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "NZ Credit note.xml"));
    }
    if (aVESID.equals (PeppolValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_109))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.9/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "AU Self Billing.xml"),
                                      new FileSystemResource (sPrefix + "NZ Self Billing.xml"));
    }
    if (aVESID.equals (PeppolValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_109))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.9/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "NZ Self Billed Credit note.xml"));
    }

    // SG 1.0.2
    if (aVESID.equals (PeppolValidationSG.VID_OPENPEPPOL_BIS3_SG_UBL_INVOICE_102))
    {
      final String sPrefix = sPrefix0 + "sg-peppol/1.0.2/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "Singapore invoice valid 1.xml"));
    }
    if (aVESID.equals (PeppolValidationSG.VID_OPENPEPPOL_BIS3_SG_UBL_CREDIT_NOTE_102))
      return new CommonsArrayList <> ();

    // SG 1.0.3
    if (aVESID.equals (PeppolValidationSG.VID_OPENPEPPOL_BIS3_SG_UBL_INVOICE_103))
    {
      final String sPrefix = sPrefix0 + "sg-peppol/1.0.3/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "Singapore invoice valid 1.xml"),
                                      new FileSystemResource (sPrefix + "Singapore invoice valid 1 - NG tax code.xml"));
    }
    if (aVESID.equals (PeppolValidationSG.VID_OPENPEPPOL_BIS3_SG_UBL_CREDIT_NOTE_103))
      return new CommonsArrayList <> ();

    // SG 2023.07
    if (aVESID.equals (PeppolValidationSG.VID_OPENPEPPOL_BIS3_SG_UBL_INVOICE_2023_07))
    {
      final String sPrefix = sPrefix0 + "sg-peppol/2023.7/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "SG INV example 02 - full valid invoice 1.xml"),
                                      new FileSystemResource (sPrefix +
                                                              "SG INV example 03 - Allowances and Charges.xml"),
                                      new FileSystemResource (sPrefix + "SG INV example 04 - none GST registered.xml"),
                                      new FileSystemResource (sPrefix +
                                                              "SG INV example 05 - AGD compliant with II and PO reference.xml"),
                                      new FileSystemResource (sPrefix + "SG INV example 06 - Foreign currency.xml"),
                                      new FileSystemResource (sPrefix + "SG INV example 07 - Foreign buyer.xml"),
                                      new FileSystemResource (sPrefix + "SG INV example 08 - Factored invoice.xml"),
                                      new FileSystemResource (sPrefix + "SG INV example 09 - Zero rated GST.xml"),
                                      new FileSystemResource (sPrefix + "SG INV example 10 - Prepayment.xml"),
                                      new FileSystemResource (sPrefix + "SG INV example 11 - Decimals.xml"),
                                      new FileSystemResource (sPrefix + "SG INV example 12 - SG bank transfer.xml"),
                                      new FileSystemResource (sPrefix + "SG INV example 13 - SG GIRO.xml"),
                                      new FileSystemResource (sPrefix + "SG INV example 14 - PayNow.xml"),
                                      new FileSystemResource (sPrefix + "SG INV example 15 - Credit card.xml"),
                                      new FileSystemResource (sPrefix + "SG INV example 16 - GST in SGD.xml"),
                                      new FileSystemResource (sPrefix +
                                                              "SG INV example 16b - GST in SGD With Several Errors.xml"));
    }
    if (aVESID.equals (PeppolValidationSG.VID_OPENPEPPOL_BIS3_SG_UBL_CREDIT_NOTE_103))
    {
      final String sPrefix = sPrefix0 + "sg-peppol/2023.7/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "SG CN example 01 - Credit Note.xml"));
    }

    // 3.15.0
    {
      final String sPrefix = sPrefix0 + "openpeppol/3.15.0/";
      // https://github.com/OpenPEPPOL/peppol-bis-invoice-3/tree/master/rules/examples
      if (aVESID.equals (PeppolValidation3_15_0.VID_OPENPEPPOL_INVOICE_UBL_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "billing/Allowance-example.xml"),
                                        new FileSystemResource (sPrefix + "billing/base-example.xml"),
                                        new FileSystemResource (sPrefix + "billing/base-negative-inv-correction.xml"),
                                        new FileSystemResource (sPrefix + "billing/vat-category-E.xml"),
                                        new FileSystemResource (sPrefix + "billing/vat-category-O.xml"),
                                        new FileSystemResource (sPrefix + "billing/Vat-category-S.xml"),
                                        new FileSystemResource (sPrefix + "billing/vat-category-Z.xml"));
      if (aVESID.equals (PeppolValidation3_15_0.VID_OPENPEPPOL_CREDIT_NOTE_UBL_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "billing/base-creditnote-correction.xml"));
      if (aVESID.equals (PeppolValidation3_15_0.VID_OPENPEPPOL_INVOICE_CII_V3))
        return new CommonsArrayList <> ();
      if (aVESID.equals (PeppolValidation3_15_0.VID_OPENPEPPOL_ORDER_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "Order_Example.xml"),
                                        new FileSystemResource (sPrefix + "Order use cases/UC1_Order.xml"),
                                        new FileSystemResource (sPrefix + "Order use cases/UC2_Order.xml"),
                                        new FileSystemResource (sPrefix + "Order use cases/UC3_Order.xml"),
                                        new FileSystemResource (sPrefix + "Order use cases/UC4_Order.xml"),
                                        new FileSystemResource (sPrefix + "Order use cases/UC5_Order.xml"));
      if (aVESID.equals (PeppolValidation3_15_0.VID_OPENPEPPOL_DESPATCH_ADVICE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "DespatchAdvice_Example.xml"),
                                        new FileSystemResource (sPrefix +
                                                                "Despatch Advice use cases/DespatchAdvice-BIS3_UseCase1.xml"),
                                        new FileSystemResource (sPrefix +
                                                                "Despatch Advice use cases/DespatchAdvice-BIS3_UseCase2.xml"),
                                        new FileSystemResource (sPrefix +
                                                                "Despatch Advice use cases/DespatchAdvice-BIS3_UseCase3.xml"),
                                        new FileSystemResource (sPrefix +
                                                                "Despatch Advice use cases/DespatchAdvice-BIS3_UseCase4.xml"),
                                        new FileSystemResource (sPrefix +
                                                                "Despatch Advice use cases/DespatchAdvice-BIS3_UseCase5.xml"));
      if (aVESID.equals (PeppolValidation3_15_0.VID_OPENPEPPOL_CATALOGUE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "Catalogue_Example.xml"));
      if (aVESID.equals (PeppolValidation3_15_0.VID_OPENPEPPOL_CATALOGUE_RESPONSE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "CatalogueResponse_Example.xml"));
      if (aVESID.equals (PeppolValidation3_15_0.VID_OPENPEPPOL_MLR_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "MessageLevelResponse_Example.xml"));
      if (aVESID.equals (PeppolValidation3_15_0.VID_OPENPEPPOL_ORDER_RESPONSE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "OrderResponse_Example.xml"),
                                        new FileSystemResource (sPrefix +
                                                                "Order-response use cases/UC1_Order_response.xml"),
                                        new FileSystemResource (sPrefix +
                                                                "Order-response use cases/UC2_Order_response.xml"),
                                        new FileSystemResource (sPrefix +
                                                                "Order-response use cases/UC3_Order_response.xml"),
                                        new FileSystemResource (sPrefix +
                                                                "Order-response use cases/UC4_Order_response.xml"),
                                        new FileSystemResource (sPrefix +
                                                                "Order-response use cases/UC5_Order_response.xml"));
      if (aVESID.equals (PeppolValidation3_15_0.VID_OPENPEPPOL_PUNCH_OUT_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "PunchOut_Example.xml"));
      if (aVESID.equals (PeppolValidation3_15_0.VID_OPENPEPPOL_ORDER_AGREEMENT_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "OrderAgreement_Example.xml"));

      final String sBase2 = sPrefix + "Invoice reponse use cases/";
      if (aVESID.equals (PeppolValidation3_15_0.VID_OPENPEPPOL_INVOICE_MESSAGE_RESPONSE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "InvoiceResponse_Example.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc001-Invoice in process.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc002a-Additional reference data.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc002b-In process but postponed.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc003-Invoice is accepted.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc004a-Invoice is rejected.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc004b-Rejected requesting reissue.xml"),
                                        new FileSystemResource (sBase2 +
                                                                "T111-uc004c-Rejected requesting replacement.xml"),
                                        new FileSystemResource (sBase2 +
                                                                "T111-uc005-Invoice is conditionally accepted.xml"),
                                        new FileSystemResource (sBase2 +
                                                                "T111-uc006a-Under query missing information.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc006b-Missing PO.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc006c-Wrong detail partial credit.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc007-Payment has been initiated.xml"),
                                        new FileSystemResource (sBase2 +
                                                                "T111-uc008-Invoice is accepted by third party.xml"));
    }

    // 2023-05
    {
      final String sPrefix = sPrefix0 + "openpeppol/2023.5/";
      // https://github.com/OpenPEPPOL/peppol-bis-invoice-3/tree/master/rules/examples
      if (aVESID.equals (PeppolValidation2023_05.VID_OPENPEPPOL_INVOICE_UBL_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "billing/Allowance-example.xml"),
                                        new FileSystemResource (sPrefix + "billing/base-example.xml"),
                                        new FileSystemResource (sPrefix + "billing/base-negative-inv-correction.xml"),
                                        new FileSystemResource (sPrefix + "billing/vat-category-E.xml"),
                                        new FileSystemResource (sPrefix + "billing/vat-category-O.xml"),
                                        new FileSystemResource (sPrefix + "billing/Vat-category-S.xml"),
                                        new FileSystemResource (sPrefix + "billing/vat-category-Z.xml"));
      if (aVESID.equals (PeppolValidation2023_05.VID_OPENPEPPOL_CREDIT_NOTE_UBL_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "billing/base-creditnote-correction.xml"));
      if (aVESID.equals (PeppolValidation2023_05.VID_OPENPEPPOL_ORDER_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "Order_Example.xml"),
                                        new FileSystemResource (sPrefix + "Order use cases/UC1_Order.xml"),
                                        new FileSystemResource (sPrefix + "Order use cases/UC2_Order.xml"),
                                        new FileSystemResource (sPrefix + "Order use cases/UC3_Order.xml"),
                                        new FileSystemResource (sPrefix + "Order use cases/UC4_Order.xml"),
                                        new FileSystemResource (sPrefix + "Order use cases/UC5_Order.xml"));
      if (aVESID.equals (PeppolValidation2023_05.VID_OPENPEPPOL_DESPATCH_ADVICE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "DespatchAdvice_Example.xml"),
                                        new FileSystemResource (sPrefix +
                                                                "Despatch Advice use cases/DespatchAdvice-BIS3_UseCase1.xml"),
                                        new FileSystemResource (sPrefix +
                                                                "Despatch Advice use cases/DespatchAdvice-BIS3_UseCase2.xml"),
                                        new FileSystemResource (sPrefix +
                                                                "Despatch Advice use cases/DespatchAdvice-BIS3_UseCase3.xml"),
                                        new FileSystemResource (sPrefix +
                                                                "Despatch Advice use cases/DespatchAdvice-BIS3_UseCase4.xml"),
                                        new FileSystemResource (sPrefix +
                                                                "Despatch Advice use cases/DespatchAdvice-BIS3_UseCase5.xml"));
      if (aVESID.equals (PeppolValidation2023_05.VID_OPENPEPPOL_CATALOGUE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "Catalogue_Example.xml"));
      if (aVESID.equals (PeppolValidation2023_05.VID_OPENPEPPOL_CATALOGUE_RESPONSE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "CatalogueResponse_Example.xml"));
      if (aVESID.equals (PeppolValidation2023_05.VID_OPENPEPPOL_MLR_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "MessageLevelResponse_Example.xml"));
      if (aVESID.equals (PeppolValidation2023_05.VID_OPENPEPPOL_ORDER_RESPONSE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "OrderResponse_Example.xml"),
                                        new FileSystemResource (sPrefix +
                                                                "Order-response use cases/UC1_Order_response.xml"),
                                        new FileSystemResource (sPrefix +
                                                                "Order-response use cases/UC2_Order_response.xml"),
                                        new FileSystemResource (sPrefix +
                                                                "Order-response use cases/UC3_Order_response.xml"),
                                        new FileSystemResource (sPrefix +
                                                                "Order-response use cases/UC4_Order_response.xml"),
                                        new FileSystemResource (sPrefix +
                                                                "Order-response use cases/UC5_Order_response.xml"));
      if (aVESID.equals (PeppolValidation2023_05.VID_OPENPEPPOL_PUNCH_OUT_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "PunchOut_Example.xml"));
      if (aVESID.equals (PeppolValidation2023_05.VID_OPENPEPPOL_ORDER_AGREEMENT_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "OrderAgreement_Example.xml"));

      final String sBase2 = sPrefix + "Invoice reponse use cases/";
      if (aVESID.equals (PeppolValidation2023_05.VID_OPENPEPPOL_INVOICE_MESSAGE_RESPONSE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "InvoiceResponse_Example.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc001-Invoice in process.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc002a-Additional reference data.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc002b-In process but postponed.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc003-Invoice is accepted.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc004a-Invoice is rejected.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc004b-Rejected requesting reissue.xml"),
                                        new FileSystemResource (sBase2 +
                                                                "T111-uc004c-Rejected requesting replacement.xml"),
                                        new FileSystemResource (sBase2 +
                                                                "T111-uc005-Invoice is conditionally accepted.xml"),
                                        new FileSystemResource (sBase2 +
                                                                "T111-uc006a-Under query missing information.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc006b-Missing PO.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc006c-Wrong detail partial credit.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc007-Payment has been initiated.xml"),
                                        new FileSystemResource (sBase2 +
                                                                "T111-uc008-Invoice is accepted by third party.xml"));

      if (aVESID.equals (PeppolValidation2023_05.VID_OPENPEPPOL_ORDER_CHANGE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "OrderChange_Example.xml"));
      if (aVESID.equals (PeppolValidation2023_05.VID_OPENPEPPOL_ORDER_CANCELLATION_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "OrderCancellation_Example.xml"));
      if (aVESID.equals (PeppolValidation2023_05.VID_OPENPEPPOL_ORDER_RESPONSE_ADVANCED_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "OrderResponseAdvanced_Example.xml"));
    }

    /* Peppol Directory BusinessCard */
    if (aVESID.equals (PeppolValidationDirectory.VID_OPENPEPPOL_BUSINESS_CARD_V1))
    {
      final String sPrefix = sPrefix0 + "business-card/v1/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "bc-0088-5033466000005.xml"),
                                      new FileSystemResource (sPrefix + "bc-9915-leckma.xml"),
                                      new FileSystemResource (sPrefix + "business-card-example-spec-v1.xml"),
                                      new FileSystemResource (sPrefix + "business-card-test1.xml"));
    }
    if (aVESID.equals (PeppolValidationDirectory.VID_OPENPEPPOL_BUSINESS_CARD_V2))
    {
      final String sPrefix = sPrefix0 + "business-card/v2/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "bc-0088-5033466000005.xml"),
                                      new FileSystemResource (sPrefix + "bc-9915-leckma.xml"),
                                      new FileSystemResource (sPrefix + "business-card-example-spec-v2.xml"),
                                      new FileSystemResource (sPrefix + "business-card-test1.xml"),
                                      new FileSystemResource (sPrefix + "nemhandel.xml"));
    }
    if (aVESID.equals (PeppolValidationDirectory.VID_OPENPEPPOL_BUSINESS_CARD_V3))
    {
      final String sPrefix = sPrefix0 + "business-card/v3/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "bc-0088-5033466000005.xml"),
                                      new FileSystemResource (sPrefix + "bc1.xml"),
                                      new FileSystemResource (sPrefix + "bc-9915-leckma.xml"),
                                      new FileSystemResource (sPrefix + "bc-9930-de811152493.xml"),
                                      new FileSystemResource (sPrefix + "business-card-cctf-103.xml"),
                                      new FileSystemResource (sPrefix + "business-card-example-spec-v3.xml"),
                                      new FileSystemResource (sPrefix + "business-card-test1.xml"),
                                      new FileSystemResource (sPrefix + "business-card-test2.xml"));
    }

    /* Peppol Reporting */
    // EUSR
    if (aVESID.equals (PeppolValidationReporting.VID_OPENPEPPOL_EUSR_V100RC2))
    {
      final String sPrefix = sPrefix0 + "reporting/eusr/1.0.0-RC2/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "end-user-statistics-reporting-1.xml"),
                                      new FileSystemResource (sPrefix + "end-user-statistics-reporting-empty.xml"),
                                      new FileSystemResource (sPrefix + "end-user-statistics-reporting-minimal.xml"));
    }
    if (aVESID.equals (PeppolValidationReporting.VID_OPENPEPPOL_EUSR_V100))
    {
      final String sPrefix = sPrefix0 + "reporting/eusr/1.0.0/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "end-user-statistics-reporting-1.xml"),
                                      new FileSystemResource (sPrefix + "end-user-statistics-reporting-empty.xml"),
                                      new FileSystemResource (sPrefix + "end-user-statistics-reporting-minimal.xml"));
    }
    if (aVESID.equals (PeppolValidationReporting.VID_OPENPEPPOL_EUSR_V101))
    {
      final String sPrefix = sPrefix0 + "reporting/eusr/1.0.1/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "end-user-statistics-reporting-1.xml"),
                                      new FileSystemResource (sPrefix + "end-user-statistics-reporting-2.xml"),
                                      new FileSystemResource (sPrefix + "end-user-statistics-reporting-empty.xml"),
                                      new FileSystemResource (sPrefix + "end-user-statistics-reporting-minimal.xml"));
    }
    if (aVESID.equals (PeppolValidationReporting.VID_OPENPEPPOL_EUSR_V110))
    {
      final String sPrefix = sPrefix0 + "reporting/eusr/1.1.0/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "end-user-statistics-reporting-1.xml"),
                                      new FileSystemResource (sPrefix + "end-user-statistics-reporting-2.xml"),
                                      new FileSystemResource (sPrefix + "end-user-statistics-reporting-empty.xml"),
                                      new FileSystemResource (sPrefix + "end-user-statistics-reporting-minimal.xml"),
                                      new FileSystemResource (sPrefix + "eusr-generated-1.xml"),
                                      new FileSystemResource (sPrefix + "eusr-good-template.xml"));
    }
    if (aVESID.equals (PeppolValidationReporting.VID_OPENPEPPOL_EUSR_V111))
    {
      final String sPrefix = sPrefix0 + "reporting/eusr/1.1.1/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "end-user-statistics-reporting-1.xml"),
                                      new FileSystemResource (sPrefix + "end-user-statistics-reporting-2.xml"),
                                      new FileSystemResource (sPrefix + "end-user-statistics-reporting-empty.xml"),
                                      new FileSystemResource (sPrefix + "end-user-statistics-reporting-minimal.xml"),
                                      new FileSystemResource (sPrefix + "eusr-generated-1.xml"),
                                      new FileSystemResource (sPrefix + "eusr-good-template.xml"));
    }

    // TSR
    if (aVESID.equals (PeppolValidationReporting.VID_OPENPEPPOL_TSR_V100))
    {
      final String sPrefix = sPrefix0 + "reporting/tsr/1.0.0/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "transaction-statistics-2.xml"),
                                      new FileSystemResource (sPrefix + "transaction-statistics-minimal.xml"));
    }
    if (aVESID.equals (PeppolValidationReporting.VID_OPENPEPPOL_TSR_V101))
    {
      final String sPrefix = sPrefix0 + "reporting/tsr/1.0.1/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "transaction-statistics-2.xml"),
                                      new FileSystemResource (sPrefix + "transaction-statistics-minimal.xml"));
    }
    if (aVESID.equals (PeppolValidationReporting.VID_OPENPEPPOL_TSR_V102))
    {
      final String sPrefix = sPrefix0 + "reporting/tsr/1.0.2/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "transaction-statistics-2.xml"),
                                      new FileSystemResource (sPrefix + "transaction-statistics-minimal.xml"));
    }
    /* Peppol JP */
    if (aVESID.equals (PeppolValidationJP.VID_OPENPEPPOL_JP_PINT_INVOICE_012))
    {
      final String sPrefix = sPrefix0 + "jp-pint/0.1.2/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "Japan PINT Invoice UBL Example.xml"),
                                      new FileSystemResource (sPrefix + "Japan PINT Invoice UBL Example1-minimum.xml"),
                                      new FileSystemResource (sPrefix +
                                                              "Japan PINT Invoice UBL Example2-TaxAcctCur.xml"),
                                      new FileSystemResource (sPrefix + "Japan PINT Invoice UBL Example3-SumInv1.xml"),
                                      new FileSystemResource (sPrefix + "Japan PINT Invoice UBL Example4-SumInv2.xml"),
                                      new FileSystemResource (sPrefix +
                                                              "Japan PINT Invoice UBL Example5-AllowanceCharge.xml"),
                                      new FileSystemResource (sPrefix + "Japan PINT Invoice UBL Example6-CorrInv.xml"),
                                      new FileSystemResource (sPrefix +
                                                              "Japan PINT Invoice UBL Example7-Return.Quan.ItPr.xml"),
                                      new FileSystemResource (sPrefix +
                                                              "Japan PINT Invoice UBL Example9-SumInv1 and O.xml"));
    }
    if (aVESID.equals (PeppolValidationJP.VID_OPENPEPPOL_JP_PINT_CREDIT_NOTE_012))
    {
      return new CommonsArrayList <> ();
    }
    throw new IllegalArgumentException ("Invalid VESID: " + aVESID);
  }
}
