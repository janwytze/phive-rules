/**
 * Copyright (C) 2014-2021 Philip Helger (www.helger.com)
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
package com.helger.phive.peppol.legacy.mock;

import javax.annotation.Nonnull;
import javax.annotation.concurrent.Immutable;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.annotation.ReturnsMutableCopy;
import com.helger.commons.collection.impl.CommonsArrayList;
import com.helger.commons.collection.impl.ICommonsList;
import com.helger.commons.io.resource.FileSystemResource;
import com.helger.commons.io.resource.IReadableResource;
import com.helger.peppol.testfiles.official.OfficialTestFiles;
import com.helger.phive.api.executorset.VESID;
import com.helger.phive.api.executorset.ValidationExecutorSetRegistry;
import com.helger.phive.engine.mock.MockFile;
import com.helger.phive.engine.source.IValidationSourceXML;
import com.helger.phive.peppol.legacy.PeppolLegacyThirdpartyValidation;
import com.helger.phive.peppol.legacy.PeppolLegacyValidation;
import com.helger.phive.peppol.legacy.PeppolValidation370;
import com.helger.phive.peppol.legacy.PeppolValidation381;
import com.helger.phive.peppol.legacy.PeppolValidation390;
import com.helger.phive.peppol.legacy.PeppolValidation391;
import com.helger.phive.peppol.legacy.PeppolValidation3_10_0;
import com.helger.phive.peppol.legacy.PeppolValidation3_10_1;

@Immutable
@SuppressWarnings ("deprecation")
public final class CTestFiles
{
  public static final ValidationExecutorSetRegistry <IValidationSourceXML> VES_REGISTRY = new ValidationExecutorSetRegistry <> ();
  static
  {
    PeppolLegacyValidation.initStandard (VES_REGISTRY);
    PeppolLegacyThirdpartyValidation.initThirdParty (VES_REGISTRY);
  }

  private CTestFiles ()
  {}

  @Nonnull
  @ReturnsMutableCopy
  public static ICommonsList <MockFile> getAllTestFiles ()
  {
    final ICommonsList <MockFile> ret = new CommonsArrayList <> ();
    for (final VESID aESID : new VESID [] { PeppolValidation370.VID_OPENPEPPOL_T19_V2,
                                            PeppolValidation370.VID_OPENPEPPOL_T58_V2,
                                            PeppolValidation370.VID_OPENPEPPOL_T01_V2,
                                            PeppolValidation370.VID_OPENPEPPOL_T10_V2,
                                            PeppolValidation370.VID_OPENPEPPOL_T14_V2,
                                            PeppolValidation370.VID_OPENPEPPOL_T76_V2,
                                            PeppolValidation370.VID_OPENPEPPOL_T16_V2,
                                            PeppolValidation370.VID_OPENPEPPOL_BIS3_UBL_INVOICE,
                                            PeppolValidation370.VID_OPENPEPPOL_BIS3_UBL_CREDIT_NOTE,

                                            PeppolValidation381.VID_OPENPEPPOL_INVOICE_V3,
                                            PeppolValidation381.VID_OPENPEPPOL_CREDIT_NOTE_V3,
                                            PeppolValidation381.VID_OPENPEPPOL_T01_V3,
                                            PeppolValidation381.VID_OPENPEPPOL_T16_V3,
                                            PeppolValidation381.VID_OPENPEPPOL_T19_V3,
                                            PeppolValidation381.VID_OPENPEPPOL_T58_V3,
                                            PeppolValidation381.VID_OPENPEPPOL_T71_V3,
                                            PeppolValidation381.VID_OPENPEPPOL_T76_V3,
                                            PeppolValidation381.VID_OPENPEPPOL_T77_V3,
                                            PeppolValidation381.VID_OPENPEPPOL_T110_V3,
                                            PeppolValidation381.VID_OPENPEPPOL_T111_V3,

                                            PeppolValidation390.VID_OPENPEPPOL_INVOICE_V3,
                                            PeppolValidation390.VID_OPENPEPPOL_CREDIT_NOTE_V3,
                                            PeppolValidation390.VID_OPENPEPPOL_T01_V3,
                                            PeppolValidation390.VID_OPENPEPPOL_T16_V3,
                                            PeppolValidation390.VID_OPENPEPPOL_T19_V3,
                                            PeppolValidation390.VID_OPENPEPPOL_T58_V3,
                                            PeppolValidation390.VID_OPENPEPPOL_T71_V3,
                                            PeppolValidation390.VID_OPENPEPPOL_T76_V3,
                                            PeppolValidation390.VID_OPENPEPPOL_T77_V3,
                                            PeppolValidation390.VID_OPENPEPPOL_T110_V3,
                                            PeppolValidation390.VID_OPENPEPPOL_T111_V3,

                                            PeppolValidation391.VID_OPENPEPPOL_INVOICE_V3,
                                            PeppolValidation391.VID_OPENPEPPOL_CREDIT_NOTE_V3,
                                            PeppolValidation391.VID_OPENPEPPOL_T01_V3,
                                            PeppolValidation391.VID_OPENPEPPOL_T16_V3,
                                            PeppolValidation391.VID_OPENPEPPOL_T19_V3,
                                            PeppolValidation391.VID_OPENPEPPOL_T58_V3,
                                            PeppolValidation391.VID_OPENPEPPOL_T71_V3,
                                            PeppolValidation391.VID_OPENPEPPOL_T76_V3,
                                            PeppolValidation391.VID_OPENPEPPOL_T77_V3,
                                            PeppolValidation391.VID_OPENPEPPOL_T110_V3,
                                            PeppolValidation391.VID_OPENPEPPOL_T111_V3,

                                            PeppolValidation3_10_0.VID_OPENPEPPOL_INVOICE_V3,
                                            PeppolValidation3_10_0.VID_OPENPEPPOL_CREDIT_NOTE_V3,
                                            PeppolValidation3_10_0.VID_OPENPEPPOL_ORDER_V3,
                                            PeppolValidation3_10_0.VID_OPENPEPPOL_DESPATCH_ADVICE_V3,
                                            PeppolValidation3_10_0.VID_OPENPEPPOL_CATALOGUE_V3,
                                            PeppolValidation3_10_0.VID_OPENPEPPOL_CATALOGUE_RESPONSE_V3,
                                            PeppolValidation3_10_0.VID_OPENPEPPOL_MLR_V3,
                                            PeppolValidation3_10_0.VID_OPENPEPPOL_ORDER_RESPONSE_V3,
                                            PeppolValidation3_10_0.VID_OPENPEPPOL_PUNCH_OUT_V3,
                                            PeppolValidation3_10_0.VID_OPENPEPPOL_ORDER_AGREEMENT_V3,
                                            PeppolValidation3_10_0.VID_OPENPEPPOL_INVOICE_MESSAGE_RESPONSE_V3,

                                            PeppolValidation3_10_1.VID_OPENPEPPOL_INVOICE_V3,
                                            PeppolValidation3_10_1.VID_OPENPEPPOL_CREDIT_NOTE_V3,
                                            PeppolValidation3_10_1.VID_OPENPEPPOL_ORDER_V3,
                                            PeppolValidation3_10_1.VID_OPENPEPPOL_DESPATCH_ADVICE_V3,
                                            PeppolValidation3_10_1.VID_OPENPEPPOL_CATALOGUE_V3,
                                            PeppolValidation3_10_1.VID_OPENPEPPOL_CATALOGUE_RESPONSE_V3,
                                            PeppolValidation3_10_1.VID_OPENPEPPOL_MLR_V3,
                                            PeppolValidation3_10_1.VID_OPENPEPPOL_ORDER_RESPONSE_V3,
                                            PeppolValidation3_10_1.VID_OPENPEPPOL_PUNCH_OUT_V3,
                                            PeppolValidation3_10_1.VID_OPENPEPPOL_ORDER_AGREEMENT_V3,
                                            PeppolValidation3_10_1.VID_OPENPEPPOL_INVOICE_MESSAGE_RESPONSE_V3, })
      for (final IReadableResource aRes : getAllMatchingTestFiles (aESID))
        ret.add (MockFile.createGoodCase (aRes, aESID));

    return ret;
  }

  @Nonnull
  @ReturnsMutableCopy
  public static ICommonsList <? extends IReadableResource> getAllMatchingTestFiles (@Nonnull final VESID aVESID)
  {
    ValueEnforcer.notNull (aVESID, "VESID");

    // 3.7.0
    {
      if (aVESID.equals (PeppolValidation370.VID_OPENPEPPOL_T19_V2))
        return OfficialTestFiles.getAllTestFilesCatalogue_01_T19 ();
      if (aVESID.equals (PeppolValidation370.VID_OPENPEPPOL_T58_V2))
        return OfficialTestFiles.getAllTestFilesCatalogue_01_T58 ();
      if (aVESID.equals (PeppolValidation370.VID_OPENPEPPOL_T01_V2))
        return OfficialTestFiles.getAllTestFilesOrder_03_T01 ();
      if (aVESID.equals (PeppolValidation370.VID_OPENPEPPOL_T10_V2))
        return OfficialTestFiles.getAllTestFilesInvoice_04_T10 ();
      if (aVESID.equals (PeppolValidation370.VID_OPENPEPPOL_T14_V2))
        return OfficialTestFiles.getAllTestFilesBilling_05_T14 ();
      if (aVESID.equals (PeppolValidation370.VID_OPENPEPPOL_T76_V2))
        return OfficialTestFiles.getAllTestFilesOrdering_28_T76 ();
      if (aVESID.equals (PeppolValidation370.VID_OPENPEPPOL_T16_V2))
        return OfficialTestFiles.getAllTestFilesDespatchAdvice_30_T16 ();
      if (aVESID.equals (PeppolValidation370.VID_OPENPEPPOL_BIS3_UBL_INVOICE))
        return new CommonsArrayList <> (new FileSystemResource ("src/test/resources/test-files/billingbis3/base-example.xml"),
                                        new FileSystemResource ("src/test/resources/test-files/billingbis3/base-negative-inv-correction.xml"));
      if (aVESID.equals (PeppolValidation370.VID_OPENPEPPOL_BIS3_UBL_CREDIT_NOTE))
        return new CommonsArrayList <> (new FileSystemResource ("src/test/resources/test-files/billingbis3/base-creditnote-correction.xml"));
    }

    // 3.8.1
    {
      final String sBase = "src/test/resources/test-files/3.8.1/";
      if (aVESID.equals (PeppolValidation381.VID_OPENPEPPOL_INVOICE_V3))
        return new CommonsArrayList <> ();
      if (aVESID.equals (PeppolValidation381.VID_OPENPEPPOL_CREDIT_NOTE_V3))
        return new CommonsArrayList <> ();
      if (aVESID.equals (PeppolValidation381.VID_OPENPEPPOL_T01_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "Order_Example.xml"));
      if (aVESID.equals (PeppolValidation381.VID_OPENPEPPOL_T16_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "DespatchAdvice_Example.xml"));
      if (aVESID.equals (PeppolValidation381.VID_OPENPEPPOL_T19_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "Catalogue_Example.xml"));
      if (aVESID.equals (PeppolValidation381.VID_OPENPEPPOL_T58_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "CatalogueResponse_Example.xml"));
      if (aVESID.equals (PeppolValidation381.VID_OPENPEPPOL_T71_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "MessageLevelResponse_Example.xml"));
      if (aVESID.equals (PeppolValidation381.VID_OPENPEPPOL_T76_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "OrderResponse_Example.xml"));
      if (aVESID.equals (PeppolValidation381.VID_OPENPEPPOL_T77_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "PunchOut_Example.xml"));
      if (aVESID.equals (PeppolValidation381.VID_OPENPEPPOL_T110_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "OrderAgreement_Example.xml"));

      final String sBase2 = sBase + "Invoice reponse use cases/";
      if (aVESID.equals (PeppolValidation381.VID_OPENPEPPOL_T111_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "InvoiceResponse_Example.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc001-Invoice in process.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc002a-Additional reference data.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc002b-In process but postponed.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc003-Invoice is accepted.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc004a-Invoice is rejected.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc004b-Rejected requesting reissue.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc004c-Rejected requesting replacement.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc005-Invoice is conditionally accepted.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc006a-Under query missing information.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc006b-Missing PO.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc006c-Wrong detail partial credit.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc007-Payment has been initiated.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc008-Invoice is accepted by third party.xml"));
    }

    // 3.9.0
    {
      final String sBase = "src/test/resources/test-files/3.9.0/";
      // https://github.com/OpenPEPPOL/peppol-bis-invoice-3/tree/master/rules/examples
      if (aVESID.equals (PeppolValidation390.VID_OPENPEPPOL_INVOICE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "Allowance-example.xml"),
                                        new FileSystemResource (sBase + "base-example.xml"),
                                        new FileSystemResource (sBase + "base-negative-inv-correction.xml"),
                                        new FileSystemResource (sBase + "vat-category-O.xml"),
                                        new FileSystemResource (sBase + "Vat-category-S.xml"),
                                        new FileSystemResource (sBase + "vat-category-Z.xml"));
      if (aVESID.equals (PeppolValidation390.VID_OPENPEPPOL_CREDIT_NOTE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "base-creditnote-correction.xml"));
      if (aVESID.equals (PeppolValidation390.VID_OPENPEPPOL_T01_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "Order_Example.xml"));
      if (aVESID.equals (PeppolValidation390.VID_OPENPEPPOL_T16_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "DespatchAdvice_Example.xml"));
      if (aVESID.equals (PeppolValidation390.VID_OPENPEPPOL_T19_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "Catalogue_Example.xml"));
      if (aVESID.equals (PeppolValidation390.VID_OPENPEPPOL_T58_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "CatalogueResponse_Example.xml"));
      if (aVESID.equals (PeppolValidation390.VID_OPENPEPPOL_T71_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "MessageLevelResponse_Example.xml"));
      if (aVESID.equals (PeppolValidation390.VID_OPENPEPPOL_T76_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "OrderResponse_Example.xml"));
      if (aVESID.equals (PeppolValidation390.VID_OPENPEPPOL_T77_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "PunchOut_Example.xml"));
      if (aVESID.equals (PeppolValidation390.VID_OPENPEPPOL_T110_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "OrderAgreement_Example.xml"));

      final String sBase2 = sBase + "Invoice reponse use cases/";
      if (aVESID.equals (PeppolValidation390.VID_OPENPEPPOL_T111_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "InvoiceResponse_Example.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc001-Invoice in process.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc002a-Additional reference data.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc002b-In process but postponed.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc003-Invoice is accepted.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc004a-Invoice is rejected.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc004b-Rejected requesting reissue.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc004c-Rejected requesting replacement.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc005-Invoice is conditionally accepted.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc006a-Under query missing information.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc006b-Missing PO.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc006c-Wrong detail partial credit.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc007-Payment has been initiated.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc008-Invoice is accepted by third party.xml"));
    }

    // 3.9.1
    {
      final String sBase = "src/test/resources/test-files/3.9.1/";
      // https://github.com/OpenPEPPOL/peppol-bis-invoice-3/tree/master/rules/examples
      if (aVESID.equals (PeppolValidation391.VID_OPENPEPPOL_INVOICE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "Allowance-example.xml"),
                                        new FileSystemResource (sBase + "base-example.xml"),
                                        new FileSystemResource (sBase + "base-negative-inv-correction.xml"),
                                        new FileSystemResource (sBase + "vat-category-O.xml"),
                                        new FileSystemResource (sBase + "Vat-category-S.xml"),
                                        new FileSystemResource (sBase + "vat-category-Z.xml"));
      if (aVESID.equals (PeppolValidation391.VID_OPENPEPPOL_CREDIT_NOTE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "base-creditnote-correction.xml"));
      if (aVESID.equals (PeppolValidation391.VID_OPENPEPPOL_T01_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "Order_Example.xml"));
      if (aVESID.equals (PeppolValidation391.VID_OPENPEPPOL_T16_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "DespatchAdvice_Example.xml"));
      if (aVESID.equals (PeppolValidation391.VID_OPENPEPPOL_T19_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "Catalogue_Example.xml"));
      if (aVESID.equals (PeppolValidation391.VID_OPENPEPPOL_T58_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "CatalogueResponse_Example.xml"));
      if (aVESID.equals (PeppolValidation391.VID_OPENPEPPOL_T71_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "MessageLevelResponse_Example.xml"));
      if (aVESID.equals (PeppolValidation391.VID_OPENPEPPOL_T76_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "OrderResponse_Example.xml"));
      if (aVESID.equals (PeppolValidation391.VID_OPENPEPPOL_T77_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "PunchOut_Example.xml"));
      if (aVESID.equals (PeppolValidation391.VID_OPENPEPPOL_T110_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "OrderAgreement_Example.xml"));

      final String sBase2 = sBase + "Invoice reponse use cases/";
      if (aVESID.equals (PeppolValidation391.VID_OPENPEPPOL_T111_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "InvoiceResponse_Example.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc001-Invoice in process.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc002a-Additional reference data.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc002b-In process but postponed.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc003-Invoice is accepted.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc004a-Invoice is rejected.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc004b-Rejected requesting reissue.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc004c-Rejected requesting replacement.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc005-Invoice is conditionally accepted.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc006a-Under query missing information.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc006b-Missing PO.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc006c-Wrong detail partial credit.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc007-Payment has been initiated.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc008-Invoice is accepted by third party.xml"));
    }

    // 3.10.0
    {
      final String sBase = "src/test/resources/test-files/3.10.0/";
      // https://github.com/OpenPEPPOL/peppol-bis-invoice-3/tree/master/rules/examples
      if (aVESID.equals (PeppolValidation3_10_0.VID_OPENPEPPOL_INVOICE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "billing/Allowance-example.xml"),
                                        new FileSystemResource (sBase + "billing/base-example.xml"),
                                        new FileSystemResource (sBase + "billing/base-negative-inv-correction.xml"),
                                        new FileSystemResource (sBase + "billing/vat-category-E.xml"),
                                        new FileSystemResource (sBase + "billing/vat-category-O.xml"),
                                        new FileSystemResource (sBase + "billing/Vat-category-S.xml"),
                                        new FileSystemResource (sBase + "billing/vat-category-Z.xml"));
      if (aVESID.equals (PeppolValidation3_10_0.VID_OPENPEPPOL_CREDIT_NOTE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "billing/base-creditnote-correction.xml"));
      if (aVESID.equals (PeppolValidation3_10_0.VID_OPENPEPPOL_ORDER_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "Order_Example.xml"));
      if (aVESID.equals (PeppolValidation3_10_0.VID_OPENPEPPOL_DESPATCH_ADVICE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "DespatchAdvice_Example.xml"));
      if (aVESID.equals (PeppolValidation3_10_0.VID_OPENPEPPOL_CATALOGUE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "Catalogue_Example.xml"));
      if (aVESID.equals (PeppolValidation3_10_0.VID_OPENPEPPOL_CATALOGUE_RESPONSE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "CatalogueResponse_Example.xml"));
      if (aVESID.equals (PeppolValidation3_10_0.VID_OPENPEPPOL_MLR_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "MessageLevelResponse_Example.xml"));
      if (aVESID.equals (PeppolValidation3_10_0.VID_OPENPEPPOL_ORDER_RESPONSE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "OrderResponse_Example.xml"));
      if (aVESID.equals (PeppolValidation3_10_0.VID_OPENPEPPOL_PUNCH_OUT_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "PunchOut_Example.xml"));
      if (aVESID.equals (PeppolValidation3_10_0.VID_OPENPEPPOL_ORDER_AGREEMENT_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "OrderAgreement_Example.xml"));

      final String sBase2 = sBase + "Invoice reponse use cases/";
      if (aVESID.equals (PeppolValidation3_10_0.VID_OPENPEPPOL_INVOICE_MESSAGE_RESPONSE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "InvoiceResponse_Example.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc001-Invoice in process.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc002a-Additional reference data.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc002b-In process but postponed.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc003-Invoice is accepted.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc004a-Invoice is rejected.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc004b-Rejected requesting reissue.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc004c-Rejected requesting replacement.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc005-Invoice is conditionally accepted.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc006a-Under query missing information.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc006b-Missing PO.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc006c-Wrong detail partial credit.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc007-Payment has been initiated.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc008-Invoice is accepted by third party.xml"));
    }

    // 3.10.1
    {
      final String sBase = "src/test/resources/test-files/3.10.1/";
      // https://github.com/OpenPEPPOL/peppol-bis-invoice-3/tree/master/rules/examples
      if (aVESID.equals (PeppolValidation3_10_1.VID_OPENPEPPOL_INVOICE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "billing/Allowance-example.xml"),
                                        new FileSystemResource (sBase + "billing/base-example.xml"),
                                        new FileSystemResource (sBase + "billing/base-negative-inv-correction.xml"),
                                        new FileSystemResource (sBase + "billing/vat-category-E.xml"),
                                        new FileSystemResource (sBase + "billing/vat-category-O.xml"),
                                        new FileSystemResource (sBase + "billing/Vat-category-S.xml"),
                                        new FileSystemResource (sBase + "billing/vat-category-Z.xml"));
      if (aVESID.equals (PeppolValidation3_10_1.VID_OPENPEPPOL_CREDIT_NOTE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "billing/base-creditnote-correction.xml"));
      if (aVESID.equals (PeppolValidation3_10_1.VID_OPENPEPPOL_ORDER_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "Order_Example.xml"));
      if (aVESID.equals (PeppolValidation3_10_1.VID_OPENPEPPOL_DESPATCH_ADVICE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "DespatchAdvice_Example.xml"));
      if (aVESID.equals (PeppolValidation3_10_1.VID_OPENPEPPOL_CATALOGUE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "Catalogue_Example.xml"));
      if (aVESID.equals (PeppolValidation3_10_1.VID_OPENPEPPOL_CATALOGUE_RESPONSE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "CatalogueResponse_Example.xml"));
      if (aVESID.equals (PeppolValidation3_10_1.VID_OPENPEPPOL_MLR_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "MessageLevelResponse_Example.xml"));
      if (aVESID.equals (PeppolValidation3_10_1.VID_OPENPEPPOL_ORDER_RESPONSE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "OrderResponse_Example.xml"));
      if (aVESID.equals (PeppolValidation3_10_1.VID_OPENPEPPOL_PUNCH_OUT_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "PunchOut_Example.xml"));
      if (aVESID.equals (PeppolValidation3_10_1.VID_OPENPEPPOL_ORDER_AGREEMENT_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "OrderAgreement_Example.xml"));

      final String sBase2 = sBase + "Invoice reponse use cases/";
      if (aVESID.equals (PeppolValidation3_10_1.VID_OPENPEPPOL_INVOICE_MESSAGE_RESPONSE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "InvoiceResponse_Example.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc001-Invoice in process.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc002a-Additional reference data.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc002b-In process but postponed.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc003-Invoice is accepted.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc004a-Invoice is rejected.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc004b-Rejected requesting reissue.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc004c-Rejected requesting replacement.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc005-Invoice is conditionally accepted.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc006a-Under query missing information.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc006b-Missing PO.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc006c-Wrong detail partial credit.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc007-Payment has been initiated.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc008-Invoice is accepted by third party.xml"));
    }

    throw new IllegalArgumentException ("Invalid VESID: " + aVESID);
  }
}
