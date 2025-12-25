import 'package:fluttersampleachitecture/core/constants/app_color.dart';

import 'app_image_widget.dart';
import 'package:flutter/material.dart';

class ImageWidgetShowcaseScreen extends StatelessWidget {
  const ImageWidgetShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AppImageWidget Showcase'),
        backgroundColor: AppColor.customColorName,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [


            _buildSection(
              title: 'Network Images',
              children: [
                _buildExample(
                  'Basic Network Image',
                  AppImageWidget(
                    imagePath: 'https://picsum.photos/200/200?random=1',

                    width: 150,
                    height: 150,
                  ),
                ),
                _buildExample(
                  'Network with Border Radius',
                  AppImageWidget(
                    imagePath: 'https://picsum.photos/200/200?random=2',
                    width: 150,
                    height: 150,
                    borderRadius: 12,
                  ),
                ),
                _buildExample(
                  'Network with Caching',
                  AppImageWidget(
                    imagePath: 'https://picsum.photos/200/200?random=3',
                    width: 150,
                    height: 150,
                    useCache: true,
                    borderRadius: 8,
                  ),
                ),
              ],
            ),
            _buildSection(
              title: 'BoxFit Options',
              children: [
                _buildExample(
                  'BoxFit.cover',
                  AppImageWidget(
                    imagePath: 'https://picsum.photos/200/300?random=4',
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                    borderRadius: 8,
                  ),
                ),
                _buildExample(
                  'BoxFit.contain',
                  AppImageWidget(
                    imagePath: 'https://picsum.photos/200/300?random=5',
                    width: 150,
                    height: 150,
                    fit: BoxFit.contain,
                    borderRadius: 8,
                    backgroundColor: Colors.grey[200],
                  ),
                ),
                _buildExample(
                  'BoxFit.fill',
                  AppImageWidget(
                    imagePath: 'https://picsum.photos/200/300?random=6',
                    width: 150,
                    height: 150,
                    fit: BoxFit.fill,
                    borderRadius: 8,
                  ),
                ),
              ],
            ),
            _buildSection(
              title: 'Circular Images',
              children: [
                _buildExample(
                  'Circular Network Image',
                  AppImageWidget(
                    imagePath: 'https://picsum.photos/200/200?random=7',
                    width: 100,
                    height: 100,
                    isCircular: true,
                  ),
                ),
                _buildExample(
                  'Circular with Shadow',
                  AppImageWidget(
                    imagePath: 'https://picsum.photos/200/200?random=8',
                    width: 100,
                    height: 100,
                    isCircular: true,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),
                _buildExample(
                  'Circular Icon',
                  AppImageWidget(
                    icon: Icons.person,
                    iconColor: Colors.blue,
                    iconSize: 40,
                    width: 100,
                    height: 100,
                    isCircular: true,
                    backgroundColor: Colors.blue[50],
                  ),
                ),
              ],
            ),
            _buildSection(
              title: 'Icons',
              children: [
                _buildExample(
                  'Basic Icon',
                  AppImageWidget(
                    icon: Icons.home,
                    iconColor: AppColor.customColorName,
                    iconSize: 48,
                    width: 80,
                    height: 80,
                  ),
                ),
                _buildExample(
                  'Icon with Background',
                  AppImageWidget(
                    icon: Icons.favorite,
                    iconColor: Colors.red,
                    iconSize: 40,
                    width: 80,
                    height: 80,
                    backgroundColor: Colors.red[50],
                    borderRadius: 12,
                  ),
                ),
                _buildExample(
                  'Circular Icon',
                  AppImageWidget(
                    icon: Icons.settings,
                    iconColor: Colors.white,
                    iconSize: 32,
                    width: 80,
                    height: 80,
                    isCircular: true,
                    backgroundColor: Colors.grey[800],
                  ),
                ),
              ],
            ),
            _buildSection(
              title: 'Styling Options',
              children: [
                _buildExample(
                  'With Shadow',
                  AppImageWidget(
                    imagePath: 'https://picsum.photos/200/200?random=9',
                    width: 150,
                    height: 150,
                    borderRadius: 12,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),
                _buildExample(
                  'With Background Color',
                  AppImageWidget(
                    imagePath: 'https://picsum.photos/200/200?random=10',
                    width: 150,
                    height: 150,
                    borderRadius: 12,
                    backgroundColor: Colors.grey[200],
                  ),
                ),
                _buildExample(
                  'With Opacity',
                  AppImageWidget(
                    imagePath: 'https://picsum.photos/200/200?random=11',
                    width: 150,
                    height: 150,
                    borderRadius: 12,
                    opacity: 0.7,
                  ),
                ),
              ],
            ),
            _buildSection(
              title: 'Full Screen on Tap',
              children: [
                _buildExample(
                  'Tap to View Full Screen',
                  AppImageWidget(
                    imagePath: 'https://picsum.photos/400/400?random=12',
                    width: 150,
                    height: 150,
                    borderRadius: 8,
                    enableFullScreenOnTap: true,
                    showAsDialog: true,
                    heroTag: 'showcase-1',
                  ),
                ),
                _buildExample(
                  'Full Screen Route',
                  AppImageWidget(
                    imagePath: 'https://picsum.photos/400/400?random=13',
                    width: 150,
                    height: 150,
                    borderRadius: 8,
                    enableFullScreenOnTap: true,
                    showAsDialog: false,
                    heroTag: 'showcase-2',
                  ),
                ),
              ],
            ),
            _buildSection(
              title: 'Cover Images',
              children: [
                _buildExample(
                  'Cover Image',
                  AppImageWidget(
                    imagePath: 'https://picsum.photos/400/300?random=14',
                    width: 200,
                    height: 150,
                    fit: BoxFit.cover,
                    borderRadius: 12,
                  ),
                ),
                _buildExample(
                  'Full Width Cover',
                  SizedBox(
                    width: double.infinity,
                    height: 150,
                    child: AppImageWidget(
                      imagePath: 'https://picsum.photos/800/300?random=15',
                      fit: BoxFit.cover,
                      borderRadius: 12,
                    ),
                  ),
                ),
              ],
            ),
            _buildSection(
              title: 'Loading States',
              children: [
                _buildExample(
                  'With Shimmer',
                  AppImageWidget(
                    imagePath: 'https://picsum.photos/200/200?random=16',
                    width: 150,
                    height: 150,
                    borderRadius: 8,
                    showShimmer: true,
                  ),
                ),
                _buildExample(
                  'Custom Placeholder',
                  AppImageWidget(
                    imagePath: 'https://picsum.photos/200/200?random=17',
                    width: 150,
                    height: 150,
                    borderRadius: 8,
                    showShimmer: false,
                    placeholder: const CircularProgressIndicator(),
                  ),
                ),
              ],
            ),
            _buildSection(
              title: 'Error Handling',
              children: [
                _buildExample(
                  'Invalid URL (Error)',
                  AppImageWidget(
                    imagePath:
                        'https://invalid-url-that-does-not-exist.com/image.jpg',
                    width: 150,
                    height: 150,
                    borderRadius: 8,
                  ),
                ),
                _buildExample(
                  'Custom Error Widget',
                  AppImageWidget(
                    imagePath: 'https://invalid-url.com/image.jpg',
                    width: 150,
                    height: 150,
                    borderRadius: 8,
                    errorWidget: Container(
                      color: Colors.grey[200],
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.broken_image, size: 48),
                          SizedBox(height: 8),
                          Text('Image Error', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            _buildSection(
              title: 'Different Sizes',
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildExample(
                      'Small',
                      AppImageWidget(
                        imagePath: 'https://picsum.photos/100/100?random=18',
                        width: 60,
                        height: 60,
                        borderRadius: 8,
                      ),
                    ),
                    _buildExample(
                      'Medium',
                      AppImageWidget(
                        imagePath: 'https://picsum.photos/150/150?random=19',
                        width: 100,
                        height: 100,
                        borderRadius: 12,
                      ),
                    ),
                    _buildExample(
                      'Large',
                      AppImageWidget(
                        imagePath: 'https://picsum.photos/200/200?random=20',
                        width: 150,
                        height: 150,
                        borderRadius: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            _buildSection(
              title: 'Memory Optimization',
              children: [
                _buildExample(
                  'With Cache Dimensions',
                  AppImageWidget(
                    imagePath: 'https://picsum.photos/400/400?random=21',
                    width: 150,
                    height: 150,
                    borderRadius: 8,
                    cacheWidth: 150,
                    cacheHeight: 150,
                  ),
                ),
                _buildExample(
                  'Optimized for List',
                  AppImageWidget(
                    imagePath: 'https://picsum.photos/200/200?random=22',
                    width: 80,
                    height: 80,
                    borderRadius: 8,
                    cacheWidth: 80,
                    cacheHeight: 80,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColor.customColorName,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(spacing: 16, runSpacing: 16, children: children),
        ],
      ),
    );
  }

  Widget _buildExample(String label, Widget widget) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(8),
          child: widget,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
