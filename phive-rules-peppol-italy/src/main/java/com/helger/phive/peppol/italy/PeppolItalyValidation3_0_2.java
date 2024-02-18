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
package com.helger.phive.peppol.italy;

import javax.annotation.Nonnull;
import javax.annotation.concurrent.Immutable;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.io.resource.ClassPathResource;
import com.helger.commons.io.resource.IReadableResource;
import com.helger.diver.api.version.VESID;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.api.executorset.ValidationExecutorSet;
import com.helger.phive.xml.schematron.ValidationExecutorSchematron;
import com.helger.phive.xml.source.IValidationSourceXML;
import com.helger.phive.xml.xsd.ValidationExecutorXSD;
import com.helger.ubl21.UBL21Marshaller;
import com.helger.ubl21.UBL21NamespaceContext;

/**
 * Italian Peppol validation artefacts based on BIS 3.0.14.
 *
 * @author Philip Helger
 */
@Immutable
public final class PeppolItalyValidation3_0_2
{
  // Standard resources
  public static final String VERSION_STR = "3.0.2";

  // Standard
  private static final String GROUP_ID = "it.peppol";

  public static final VESID VID_CREDIT_NOTE = new VESID (GROUP_ID, "creditnote", VERSION_STR);
  public static final VESID VID_DESPATCH_ADVICE = new VESID (GROUP_ID, "despatch-advice", VERSION_STR);
  public static final VESID VID_INVOICE = new VESID (GROUP_ID, "invoice", VERSION_STR);
  public static final VESID VID_ORDER = new VESID (GROUP_ID, "order", VERSION_STR);
  public static final VESID VID_ORDER_AGREEMENT = new VESID (GROUP_ID, "order-agreement", VERSION_STR);
  public static final VESID VID_ORDER_RESPONSE = new VESID (GROUP_ID, "order-response", VERSION_STR);

  @Nonnull
  private static ClassLoader _getCL ()
  {
    return PeppolItalyValidation3_0_2.class.getClassLoader ();
  }

  private static final String PREFIX_XSLT = "external/schematron/peppol-italy/" + VERSION_STR + "/";

  private static final IReadableResource DESPATCH_ADVICE = new ClassPathResource (PREFIX_XSLT +
                                                                                  "despatch-advice/AGID-PEPPOL-T16.xslt",
                                                                                  _getCL ());
  private static final IReadableResource INVOICE = new ClassPathResource (PREFIX_XSLT + "invoice/AGID-EN16931-UBL.xslt",
                                                                          _getCL ());
  private static final IReadableResource ORDER = new ClassPathResource (PREFIX_XSLT + "order/AGID-PEPPOL-T01.xslt",
                                                                        _getCL ());
  private static final IReadableResource ORDER_AGREEMENT = new ClassPathResource (PREFIX_XSLT +
                                                                                  "order-agreement/AGID-PEPPOL-T110.xslt",
                                                                                  _getCL ());
  private static final IReadableResource ORDER_RESPONSE = new ClassPathResource (PREFIX_XSLT +
                                                                                 "order-response/AGID-PEPPOL-T76.xslt",
                                                                                 _getCL ());

  private PeppolItalyValidation3_0_2 ()
  {}

  @Nonnull
  private static ValidationExecutorSchematron _createXSLT (@Nonnull final IReadableResource aRes)
  {
    return ValidationExecutorSchematron.createXSLT (aRes, UBL21NamespaceContext.getInstance ());
  }

  public static void init (@Nonnull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    final String sVersion = " (" + VERSION_STR + ")";
    final String sAkaVersionBIS = " (for BIS 3.0.14)";

    final boolean bNotDeprecated = false;

    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_DESPATCH_ADVICE,
                                                                           "AGID Peppol Despatch Advice" +
                                                                                                sVersion +
                                                                                                sAkaVersionBIS,
                                                                           bNotDeprecated,
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllDespatchAdviceXSDs ()),
                                                                           _createXSLT (DESPATCH_ADVICE)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_INVOICE,
                                                                           "AGID Peppol Invoice" +
                                                                                        sVersion +
                                                                                        sAkaVersionBIS,
                                                                           bNotDeprecated,
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                           _createXSLT (INVOICE)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_CREDIT_NOTE,
                                                                           "AGID Peppol Credit Note" +
                                                                                            sVersion +
                                                                                            sAkaVersionBIS,
                                                                           bNotDeprecated,
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                           _createXSLT (INVOICE)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_ORDER,
                                                                           "AGID Peppol Order" +
                                                                                      sVersion +
                                                                                      sAkaVersionBIS,
                                                                           bNotDeprecated,
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllOrderXSDs ()),
                                                                           _createXSLT (ORDER)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_ORDER_AGREEMENT,
                                                                           "AGID Peppol Order Agreement" +
                                                                                                sVersion +
                                                                                                sAkaVersionBIS,
                                                                           bNotDeprecated,
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllOrderResponseXSDs ()),
                                                                           _createXSLT (ORDER_AGREEMENT)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_ORDER_RESPONSE,
                                                                           "AGID Peppol Order Response" +
                                                                                               sVersion +
                                                                                               sAkaVersionBIS,
                                                                           bNotDeprecated,
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllOrderResponseXSDs ()),
                                                                           _createXSLT (ORDER_RESPONSE)));
  }
}
