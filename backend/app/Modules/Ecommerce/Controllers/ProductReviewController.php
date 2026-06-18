<?php

namespace App\Modules\Ecommerce\Controllers;

use App\Core\Controllers\Controller;
use App\Modules\Ecommerce\Models\Product;
use App\Modules\Ecommerce\Models\ProductReview;
use App\Modules\Ecommerce\Models\OrderItem;
use App\Modules\Ecommerce\Models\Kit;
use Illuminate\Http\Request;

class ProductReviewController extends Controller
{
    /**
     * List all approved reviews for a product.
     */
    public function index($productId)
    {
        $reviews = ProductReview::with(['user:id,name,avatar_path'])
            ->where('product_id', $productId)
            ->where('is_approved', true)
            ->orderBy('created_at', 'desc')
            ->get();

        return $this->success($reviews);
    }

    /**
     * Store a new product review.
     */
    public function store(Request $request, $productId)
    {
        $product = Product::findOrFail($productId);
        $userId = auth()->id();

        // Check if user already reviewed this product
        $existingReview = ProductReview::where('user_id', $userId)
            ->where('product_id', $productId)
            ->first();

        if ($existingReview) {
            return response()->json([
                'message' => 'Você já enviou uma avaliação para este produto.'
            ], 422);
        }

        $request->validate([
            'rating' => 'required|integer|min:1|max:5',
            'comment' => 'nullable|string|max:1000',
        ]);

        // Check if it's a verified purchase
        $purchasedDirectly = OrderItem::whereHas('order', function ($query) use ($userId) {
            $query->where('user_id', $userId)->whereIn('status', ['paid', 'shipped']);
        })
        ->where('itemable_type', Product::class)
        ->where('itemable_id', $productId)
        ->exists();

        $purchasedViaKit = OrderItem::whereHas('order', function ($query) use ($userId) {
            $query->where('user_id', $userId)->whereIn('status', ['paid', 'shipped']);
        })
        ->where('itemable_type', Kit::class)
        ->whereIn('itemable_id', function ($query) use ($productId) {
            $query->select('kit_id')
                ->from('kit_product')
                ->where('product_id', $productId);
        })
        ->exists();

        $isVerifiedPurchase = $purchasedDirectly || $purchasedViaKit;

        $review = ProductReview::create([
            'user_id' => $userId,
            'product_id' => $productId,
            'rating' => $request->rating,
            'comment' => $request->comment,
            'is_approved' => true, // default approved to display immediately
            'is_verified_purchase' => $isVerifiedPurchase,
        ]);

        return $this->success(
            $review->load(['user:id,name,avatar_path']),
            'Avaliação enviada com sucesso!',
            201
        );
    }

    /**
     * List recent 4/5 star approved reviews for the home page.
     */
    public function homeReviews()
    {
        $reviews = ProductReview::with([
            'user:id,name,avatar_path', 
            'product:id,name,slug,price,featured_image'
        ])
        ->where('is_approved', true)
        ->where('rating', '>=', 4)
        ->orderBy('created_at', 'desc')
        ->limit(6)
        ->get();

        return $this->success($reviews);
    }
}
