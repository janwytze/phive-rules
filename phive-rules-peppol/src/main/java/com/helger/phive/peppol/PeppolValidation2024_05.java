/*
 * Copyright (C) 2014-2024 Philip Helger (www.helger.com)
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
package com.helger.phive.peppol;

import java.time.LocalDate;
import java.time.Month;
import java.time.OffsetDateTime;

import javax.annotation.Nonnull;
import javax.annotation.concurrent.Immutable;

import com.helger.cii.d16b.CIID16BNamespaceContext;
import com.helger.commons.ValueEnforcer;
import com.helger.commons.collection.impl.ICommonsList;
import com.helger.commons.datetime.PDTFactory;
import com.helger.commons.io.resource.ClassPathResource;
import com.helger.commons.io.resource.IReadableResource;
import com.helger.commons.version.Version;
import com.helger.diver.api.version.VESID;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.api.executorset.ValidationExecutorSet;
import com.helger.phive.api.executorset.status.EValidationExecutorStatusType;
import com.helger.phive.api.executorset.status.IValidationExecutorSetStatus;
import com.helger.phive.api.executorset.status.ValidationExecutorSetStatus;
import com.helger.phive.api.executorset.status.ValidationExecutorSetStatusHistoryItem;
import com.helger.phive.xml.schematron.ValidationExecutorSchematron;
import com.helger.phive.xml.source.IValidationSourceXML;
import com.helger.phive.xml.xsd.ValidationExecutorXSD;
import com.helger.ubl21.UBL21Marshaller;
import com.helger.ubl21.UBL21NamespaceContext;
import com.helger.ubl23.UBL23Marshaller;

/**
 * OpenPeppol validation artefacts release 2024.5.<br>
 * May 2025 release 2024-05-27.<br>
 * Valid from Monday, 27 August 2024
 *
 * @author Philip Helger
 */
@Immutable
public final class PeppolValidation2024_05
{
  // Standard resources
  public static final Version PEPPOL_VALIDATION_ARTEFACT_VERSION = new Version (2024, 5, 0);
  public static final String VERSION_STR = PEPPOL_VALIDATION_ARTEFACT_VERSION.getAsString (false);
  public static final LocalDate VALID_PER = PDTFactory.createLocalDate (2024, Month.AUGUST, 27);
  public static final OffsetDateTime VALID_PER_UTC = PDTFactory.createOffsetDateTimeUTC (VALID_PER);

  // Standard
  private static final String GROUP_ID = "eu.peppol.bis3";
  public static final VESID VID_OPENPEPPOL_INVOICE_UBL_V3 = new VESID (GROUP_ID, "invoice", VERSION_STR);
  public static final VESID VID_OPENPEPPOL_CREDIT_NOTE_UBL_V3 = new VESID (GROUP_ID, "creditnote", VERSION_STR);
  // public static final VESID VID_OPENPEPPOL_INVOICE_CII_V3 = new VESID
  // (GROUP_ID, "invoice-cii", VERSION_STR);
  public static final VESID VID_OPENPEPPOL_ORDER_V3 = new VESID (GROUP_ID, "order", VERSION_STR);
  public static final VESID VID_OPENPEPPOL_DESPATCH_ADVICE_V3 = new VESID (GROUP_ID, "despatch-advice", VERSION_STR);
  public static final VESID VID_OPENPEPPOL_CATALOGUE_V3 = new VESID (GROUP_ID, "catalogue", VERSION_STR);
  public static final VESID VID_OPENPEPPOL_CATALOGUE_RESPONSE_V3 = new VESID (GROUP_ID,
                                                                              "catalogue-response",
                                                                              VERSION_STR);
  public static final VESID VID_OPENPEPPOL_MLR_V3 = new VESID (GROUP_ID, "mlr", VERSION_STR);
  public static final VESID VID_OPENPEPPOL_ORDER_RESPONSE_V3 = new VESID (GROUP_ID, "order-response", VERSION_STR);
  public static final VESID VID_OPENPEPPOL_PUNCH_OUT_V3 = new VESID (GROUP_ID, "punch-out", VERSION_STR);
  public static final VESID VID_OPENPEPPOL_ORDER_AGREEMENT_V3 = new VESID (GROUP_ID, "order-agreement", VERSION_STR);
  public static final VESID VID_OPENPEPPOL_INVOICE_MESSAGE_RESPONSE_V3 = new VESID (GROUP_ID,
                                                                                    "invoice-message-response",
                                                                                    VERSION_STR);
  public static final VESID VID_OPENPEPPOL_ORDER_CHANGE_V3 = new VESID (GROUP_ID, "order-change", VERSION_STR);
  public static final VESID VID_OPENPEPPOL_ORDER_CANCELLATION_V3 = new VESID (GROUP_ID,
                                                                              "order-cancellation",
                                                                              VERSION_STR);
  public static final VESID VID_OPENPEPPOL_ORDER_RESPONSE_ADVANCED_V3 = new VESID (GROUP_ID,
                                                                                   "order-response-advanced",
                                                                                   VERSION_STR);

  @Nonnull
  private static ClassLoader _getCL ()
  {
    return PeppolValidation2024_05.class.getClassLoader ();
  }

  private PeppolValidation2024_05 ()
  {}

  @Nonnull
  private static ValidationExecutorSchematron _createXsltCII (@Nonnull final IReadableResource aRes)
  {
    return ValidationExecutorSchematron.createXSLT (aRes, CIID16BNamespaceContext.getInstance ());
  }

  @Nonnull
  private static ValidationExecutorSchematron _createXsltUBL (@Nonnull final IReadableResource aRes)
  {
    return ValidationExecutorSchematron.createXSLT (aRes, UBL21NamespaceContext.getInstance ());
  }

  @Nonnull
  private static IValidationExecutorSetStatus _createStatus (final boolean bIsDeprecated)
  {
    return new ValidationExecutorSetStatus (PDTFactory.getCurrentOffsetDateTime (),
                                            bIsDeprecated ? EValidationExecutorStatusType.DEPRECATED
                                                          : EValidationExecutorStatusType.VALID,
                                            VALID_PER_UTC,
                                            (OffsetDateTime) null,
                                            (String) null,
                                            (VESID) null,
                                            (ICommonsList <ValidationExecutorSetStatusHistoryItem>) null);
  }

  public static void init (@Nonnull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    final String sVersion = " (" + VERSION_STR + ")";
    // See https://docs.peppol.eu/poacc/billing/3.0/release-notes/
    final String sAkaVersionBilling = " (aka BIS Billing 3.0.17)";
    // See https://docs.peppol.eu/poacc/upgrade-3/release-notes/
    final String sAkaVersionBIS = " (aka BIS 3.0.13)";

    final boolean bNotDeprecated = false;

    final String PREFIX_XSLT = "external/schematron/openpeppol/" + VERSION_STR + "/xslt/";
    final IReadableResource INVOICE_UBL_CEN = new ClassPathResource (PREFIX_XSLT + "CEN-EN16931-UBL.xslt", _getCL ());
    final IReadableResource INVOICE_UBL_PEPPOL = new ClassPathResource (PREFIX_XSLT + "PEPPOL-EN16931-UBL.xslt",
                                                                        _getCL ());
    final IReadableResource ORDER = new ClassPathResource (PREFIX_XSLT + "PEPPOLBIS-T01.xslt", _getCL ());
    final IReadableResource DESPATCH_ADVICE = new ClassPathResource (PREFIX_XSLT + "PEPPOLBIS-T16.xslt", _getCL ());
    final IReadableResource CATALOGUE = new ClassPathResource (PREFIX_XSLT + "PEPPOLBIS-T19.xslt", _getCL ());
    final IReadableResource CATALOGUE_RESPONSE = new ClassPathResource (PREFIX_XSLT + "PEPPOLBIS-T58.xslt", _getCL ());
    final IReadableResource MLR = new ClassPathResource (PREFIX_XSLT + "PEPPOLBIS-T71.xslt", _getCL ());
    final IReadableResource ORDER_RESPONSE = new ClassPathResource (PREFIX_XSLT + "PEPPOLBIS-T76.xslt", _getCL ());
    final IReadableResource PUNCH_OUT = new ClassPathResource (PREFIX_XSLT + "PEPPOLBIS-T77.xslt", _getCL ());
    final IReadableResource ORDER_AGREEMENT = new ClassPathResource (PREFIX_XSLT + "PEPPOLBIS-T110.xslt", _getCL ());
    final IReadableResource INVOICE_MESSAGE_RESPONSE = new ClassPathResource (PREFIX_XSLT + "PEPPOLBIS-T111.xslt",
                                                                              _getCL ());
    final IReadableResource ORDER_CHANGE = new ClassPathResource (PREFIX_XSLT + "PEPPOLBIS-T114.xslt", _getCL ());
    final IReadableResource ORDER_CANCELLATION = new ClassPathResource (PREFIX_XSLT + "PEPPOLBIS-T115.xslt", _getCL ());
    final IReadableResource ORDER_RESPONSE_ADVANCED = new ClassPathResource (PREFIX_XSLT + "PEPPOLBIS-T116.xslt",
                                                                             _getCL ());

    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_INVOICE_UBL_V3,
                                                                           "OpenPeppol UBL Invoice" +
                                                                                                          sVersion +
                                                                                                          sAkaVersionBilling,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                           _createXsltUBL (INVOICE_UBL_CEN),
                                                                           _createXsltUBL (INVOICE_UBL_PEPPOL)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_CREDIT_NOTE_UBL_V3,
                                                                           "OpenPeppol UBL Credit Note" +
                                                                                                              sVersion +
                                                                                                              sAkaVersionBilling,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                           _createXsltUBL (INVOICE_UBL_CEN),
                                                                           _createXsltUBL (INVOICE_UBL_PEPPOL)));
    // aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create
    // (VID_OPENPEPPOL_INVOICE_CII_V3,
    // "OpenPeppol CII Invoice" +
    // sVersion +
    // sAkaVersionBilling,
    // _createStatus (bNotDeprecated),
    // ValidationExecutorXSD.create (CCIID16B.getXSDResource ()),
    // _createXsltCII (INVOICE_CII_CEN),
    // _createXsltCII (INVOICE_CII_PEPPOL)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_ORDER_V3,
                                                                           "OpenPeppol Order" +
                                                                                                    sVersion +
                                                                                                    sAkaVersionBIS,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllOrderXSDs ()),
                                                                           _createXsltUBL (ORDER)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_DESPATCH_ADVICE_V3,
                                                                           "OpenPeppol Despatch Advice" +
                                                                                                              sVersion +
                                                                                                              sAkaVersionBIS,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllDespatchAdviceXSDs ()),
                                                                           _createXsltUBL (DESPATCH_ADVICE)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_CATALOGUE_V3,
                                                                           "OpenPeppol Catalogue" +
                                                                                                        sVersion +
                                                                                                        sAkaVersionBIS,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllCatalogueXSDs ()),
                                                                           _createXsltUBL (CATALOGUE)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_CATALOGUE_RESPONSE_V3,
                                                                           "OpenPeppol Catalogue Response" +
                                                                                                                 sVersion +
                                                                                                                 sAkaVersionBIS,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllApplicationResponseXSDs ()),
                                                                           _createXsltUBL (CATALOGUE_RESPONSE)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_MLR_V3,
                                                                           "OpenPeppol MLR" + sVersion + sAkaVersionBIS,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllApplicationResponseXSDs ()),
                                                                           _createXsltUBL (MLR)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_ORDER_RESPONSE_V3,
                                                                           "OpenPeppol Order Response" +
                                                                                                             sVersion +
                                                                                                             sAkaVersionBIS,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllOrderResponseXSDs ()),
                                                                           _createXsltUBL (ORDER_RESPONSE)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_PUNCH_OUT_V3,
                                                                           "OpenPeppol Punch Out" +
                                                                                                        sVersion +
                                                                                                        sAkaVersionBIS,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllCatalogueXSDs ()),
                                                                           _createXsltUBL (PUNCH_OUT)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_ORDER_AGREEMENT_V3,
                                                                           "OpenPeppol Order Agreement" +
                                                                                                              sVersion +
                                                                                                              sAkaVersionBIS,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllOrderResponseXSDs ()),
                                                                           _createXsltUBL (ORDER_AGREEMENT)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_INVOICE_MESSAGE_RESPONSE_V3,
                                                                           "OpenPeppol Invoice Message Response" +
                                                                                                                       sVersion +
                                                                                                                       sAkaVersionBIS,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllApplicationResponseXSDs ()),
                                                                           _createXsltUBL (INVOICE_MESSAGE_RESPONSE)));
    // UBL 2.3!
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_ORDER_CHANGE_V3,
                                                                           "OpenPeppol Order Change" +
                                                                                                           sVersion +
                                                                                                           sAkaVersionBIS,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllOrderChangeXSDs ()),
                                                                           _createXsltUBL (ORDER_CHANGE)));
    // UBL 2.3!
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_ORDER_CANCELLATION_V3,
                                                                           "OpenPeppol Order Cancellation" +
                                                                                                                 sVersion +
                                                                                                                 sAkaVersionBIS,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllOrderCancellationXSDs ()),
                                                                           _createXsltUBL (ORDER_CANCELLATION)));
    // UBL 2.3!
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_ORDER_RESPONSE_ADVANCED_V3,
                                                                           "OpenPeppol Order Response Advanced" +
                                                                                                                      sVersion +
                                                                                                                      sAkaVersionBIS,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllOrderResponseXSDs ()),
                                                                           _createXsltUBL (ORDER_RESPONSE_ADVANCED)));
  }
}
