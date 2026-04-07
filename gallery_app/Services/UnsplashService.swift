import Foundation

class UnsplashService {

    // let accessKey = "_03UP7N1KKImQfE4xZ4PWG6GRkaFyOw1uxBFOEkovHs"

    func fetchPhotos(page: Int, perPage: Int = 30) async throws -> [ReceivedPhotoApi] {

        var components = URLComponents(string: "https://api.unsplash.com/photos")
        components?.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "\(perPage)")
        ]

        guard let url = components?.url else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.addValue("Client-ID \(accessKey)", forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: request)

        if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
            throw URLError(.badServerResponse)
        }

        let decoder = JSONDecoder()
        return try decoder.decode([ReceivedPhotoApi].self, from: data)
    }
}
