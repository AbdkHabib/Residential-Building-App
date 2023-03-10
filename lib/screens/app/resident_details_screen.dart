import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:qatar_data_app/provider/resident_details_provider.dart';
import 'package:qatar_data_app/utils/helpers.dart';
import 'package:qatar_data_app/widgets/app_text_field.dart';
import 'package:qatar_data_app/models/note.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qatar_data_app/models/process_response.dart';
import '../../models/resident_detail.dart';
import '../../preferences/shared_pref_controller.dart';

class ResidentDetailsScreen extends StatefulWidget {
  const ResidentDetailsScreen({Key? key, this.residentDetails});

  final ResidentDetail? residentDetails;

  @override
  State<ResidentDetailsScreen> createState() => _ResidentDetailsScreenState();
}

class _ResidentDetailsScreenState extends State<ResidentDetailsScreen>
    with Helpers {
  late TextEditingController _amountTextController;
  late TextEditingController _paymentDetailsTextController;
  late TextEditingController _paymentDateTextController;
  late TextEditingController _paymentYearTextController;

  @override
  void initState() {
    super.initState();
    _amountTextController =
        TextEditingController(text: widget.residentDetails?.amount.toString());
    _paymentDetailsTextController =
        TextEditingController(text: widget.residentDetails?.paymentDetails);
    _paymentDateTextController =
        TextEditingController(text: widget.residentDetails?.paymentDate);
    _paymentYearTextController =
        TextEditingController(text: widget.residentDetails?.paymentYear);
  }

  @override
  void dispose() {
    _amountTextController.dispose();
    _paymentDetailsTextController.dispose();
    _paymentDateTextController.dispose();
    _paymentYearTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xff205375),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.nunito(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                AppLocalizations.of(context)!.note_hint,
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              AppTextField(
                textController: _amountTextController,
                hint: AppLocalizations.of(context)!.amount,
                textInputType: TextInputType.text,
                prefixIcon: Icons.currency_bitcoin,
              ),
              SizedBox(height: 20),
              AppTextField(
                textController: _paymentDateTextController,
                hint: AppLocalizations.of(context)!.payment_Date,
                textInputType: TextInputType.text,
                prefixIcon: Icons.calendar_month,
              ),
              SizedBox(height: 20),
              AppTextField(
                textController: _paymentYearTextController,
                hint: AppLocalizations.of(context)!.payment_Year,
                textInputType: TextInputType.text,
                prefixIcon: Icons.calendar_month,
              ),
              SizedBox(height: 10),
              AppTextField(
                textController: _paymentDetailsTextController,
                hint: AppLocalizations.of(context)!.payment_Details,
                textInputType: TextInputType.number,
                prefixIcon: Icons.info,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async => await _performSave(),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  primary: Color(0xff205375),
                ),
                child: Text(AppLocalizations.of(context)!.save),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String get title {
    return isNewNote
        ? AppLocalizations.of(context)!.new_statement
        : AppLocalizations.of(context)!.update_statement;
  }

  bool get isNewNote => widget.residentDetails == null;

  Future<void> _performSave() async {
    if (_checkData()) {
      await _save();
    }
  }

  bool _checkData() {
    if (_amountTextController.text.isNotEmpty &&
        _paymentDateTextController.text.isNotEmpty &&
        _paymentYearTextController.text.isNotEmpty &&
        _paymentDetailsTextController.text.isNotEmpty) {
      return true;
    }
    showSnackBar(context, message: 'Enter required data!', error: true);
    return false;
  }

  Future<void> _save() async {
    ProcessResponse processResponse = isNewNote
        ? await Provider.of<ResidentDetailsProvider>(context, listen: false)
            .create(residentDetail: residentDetail)
        : await Provider.of<ResidentDetailsProvider>(context, listen: false)
            .update(updateResidentDetail: residentDetail);

    showSnackBar(context,
        message: processResponse.message, error: !processResponse.success);
    if (processResponse.success) {
      isNewNote ? clear() : Navigator.pop(context);
    }
  }

  ResidentDetail get residentDetail {
    ResidentDetail residentDetail =
        isNewNote ? ResidentDetail() : widget.residentDetails!;
    residentDetail.amount = int.parse(_amountTextController.text);
    residentDetail.paymentDate = _paymentDateTextController.text;
    residentDetail.paymentYear = _paymentYearTextController.text;
    residentDetail.paymentDetails = _paymentDetailsTextController.text;
    residentDetail.apartmentId =
        SharedPrefController().getValueFor(key: PrefKeys.id.name)!;
    return residentDetail;
  }

  void clear() {
    _amountTextController.clear();
    _paymentDateTextController.clear();
    _paymentYearTextController.clear();
    _paymentDetailsTextController.clear();
  }
}
