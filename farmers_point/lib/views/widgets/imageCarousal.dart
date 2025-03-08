import 'package:carousel_slider/carousel_slider.dart';
import 'package:cropunity/controller/plantController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ImageCarousal extends StatefulWidget {
  final List<String> urlImages;
  const ImageCarousal({super.key, required this.urlImages});

  @override
  State<ImageCarousal> createState() => _ImageCarousalState();
}

class _ImageCarousalState extends State<ImageCarousal> {
  int activeIndex = 0;
  final carouselController = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
            carouselController: carouselController,
            itemCount: widget.urlImages.length,
            itemBuilder: (context, index, realIndex) {
              final urlImage = widget.urlImages[index];
              return ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(urlImage, fit: BoxFit.cover,height: 100,width: context.width * 0.75,));
            },
            options: CarouselOptions(
                height: 200,
                autoPlay:false,
                enableInfiniteScroll: true,
                enlargeCenterPage: true,
                onPageChanged: (index, reason) =>
                    setState(() => activeIndex = index))),
        const SizedBox(height: 12),
        Center(
          child: AnimatedSmoothIndicator(
            onDotClicked: carouselController.animateToPage,
            effect: const ExpandingDotsEffect(dotWidth: 5,dotHeight: 5, activeDotColor: Colors.blue),
            activeIndex: activeIndex,
            count: widget.urlImages.length,
          ),
        ),
      ],
    );
  }
}
