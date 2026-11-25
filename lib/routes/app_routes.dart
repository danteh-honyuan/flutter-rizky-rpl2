import 'package:flutter/material.dart';
import 'package:hello/list_grid_view/Grid_basic.dart';
import 'package:hello/pages/about_page.dart';
import 'package:hello/pages/formulir_page.dart';
import 'package:hello/pages/home_page.dart';
import 'package:hello/pages/input_page.dart';
import 'package:hello/pages/album_page.dart';

// import 'package:hello/pages/post_page.dart';

import 'package:hello/sized_expanded_stack/ExpandedWidget.dart';
import 'package:hello/pages/login_page.dart';
import 'package:hello/pages/register_page.dart';
import 'package:hello/pages/article_list_page.dart';
import 'package:hello/pages/article_form_page.dart';


// Import file-file stadion dan form tiketmu
import 'package:hello/form/StadiumHomePage.dart';
import 'package:hello/form/SeatingMapPage.dart';
import 'package:hello/form/ticket_input.dart';
import 'package:hello/form/ticket_output.dart';


class AppRoutes {
  static const home = "/home";
  static const about = "/about";
  static const sizeExpanded = "/sizeExpanded";
  static const gridbasic = "/gridbasic";
  static const formulir = "/formulir";
  static const inputForm = "/input-form";
  static const albumpage = "/albumpage";
  static const postpage = "/postpage";
  static const articleList = "/article-list";
  static const articleForm = "/article-form";

  // Rute khusus Stadion Match
  static const stadiumHome = "/stadium-home";
  static const seatingMap = "/seating-map";
  static const ticketInput = "/ticket-input";
  static const ticketOutput = "/ticket-output";
  static const login = "/login";
  static const register = "/register";

  static Map<String, WidgetBuilder> routes = {
    home: (context) => HomePage(), // Atau ubah ke StadiumHomePage() jika ingin langsung ke halaman stadion
    about: (context) => AboutPage(),
    sizeExpanded: (context) => Expandedwidget(),
    gridbasic: (context) => GridBasic(),
    formulir: (context) => FormulirPage(),
    inputForm: (context) => BelajarForm(),
    albumpage: (context) => AlbumPage (),
    // postpage: (context) => PostPage (),
    // Daftarkan rute stadion di sini
    stadiumHome: (context) => const StadiumHomePage(),
    seatingMap: (context) => const SeatingMapPage(),
    ticketInput: (context) => const TicketInputPage(),
    ticketOutput: (context) => const TicketOutputPage(),
    login: (context) => const LoginPage(),
    register: (context) => const RegisterPage(),
    articleList: (context) => const ArticleListPage(),
    articleForm: (context) => const ArticleFormPage(),
  };
}